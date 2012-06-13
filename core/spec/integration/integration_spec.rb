require 'integration_helper'

describe "Compare screens", type: :request do

  it "should render the frontpage as expected", js: true do
    u = create :user
    displaystrings = [
      "hoi",
      "hoi hoih ohiaetnoi htneoahtniahtn aeionhteoahtnaeo hni tnaeohtin haeotni haeotin heoatni haeotni hoeatni haeotni heoatnih aetnoih aetnoih aetnoi haetonih tnoaei htaenoih aetnoih aetnoihaetno hiaetnoaih aetnoi haeotni haeotnih aetnoih aeotni heoatni haeotnih tnoeahi aetnohi aetnohi aetnohi tnaohieo atnhaeiotn",
      "moi"
    ]
    3.times do |i|
      f1 = create :fact, created_by: u.graph_user
      f1.add_opinion :believes, u.graph_user
      f1.data.displaystring = displaystrings[i]
      f1.data.save
      f1.reposition_in_top_facts
    end

    visit "/"
    assume_unchanged_screenshot "homepage"
  end

  0.upto(6) do |i|
    it "should render the fake factpage with cid #{i} as expected", js: true do
      visit "/x/3?cid=#{i}"
      assume_unchanged_screenshot "fake_fact_#{i}"
    end
  end

end

describe "Check the ToS", type: :request do

  before do
    @user = make_non_tos_user_and_login
  end

  it "should contain the ToS" do
    page.should have_selector("#tos")
  end

  it "should contain the form elements" do
    page.should have_selector("input#user_agrees_tos_name")
    page.should have_selector("input#user_email")
    page.should have_selector("input#user_agrees_tos")

    page.should have_css("input#user_email[readonly]")
  end

  it "should show errors when not agreeing the ToS" do
    click_button "Finish"

    page.should have_selector("div.alert")
    page.should have_content("You have to accept the Terms of Service to continue.")
    page.should have_content("Please fill in your name to accept the Terms of Service.")
  end

  describe "when agreeing the ToS" do
    before do
      fill_in "user_agrees_tos_name", with: "Sko Brenden"
      check "user_agrees_tos"

      click_button "Finish"
    end

    it "should show the Tour", js: true do
      page.should have_selector("div#first-tour-modal", :visible => true)

      page.find(".next").click
      page.has_xpath?("//div[@data-title='Start']", :visible => true)

      page.find(".next").click
      page.has_xpath?("//div[@data-title='Factlink']", :visible => true)
      page.has_xpath?("//div[@data-title='Start']", :visible => false)

      page.find(".next").click
      page.has_xpath?("//div[@data-title='Evidence']", :visible => true)
      page.has_xpath?("//div[@data-title='Factlink']", :visible => false)


      page.find(".next").click
      page.has_xpath?("//div[@data-title='Relations']", :visible => true)
      page.has_xpath?("//div[@data-title='Evidence']", :visible => false)

      page.find(".next").click
      page.has_xpath?("//div[@data-title='Channels']", :visible => true)
      page.has_xpath?("//div[@data-title='Relations']", :visible => false)

      page.find(".next").click
      page.has_xpath?("//div[@data-title='Get Ready...']", :visible => true)
      page.has_xpath?("//div[@data-title='Channels']", :visible => false)

      page.find(".previous").click
      page.has_xpath?("//div[@data-title='Get Ready...']", :visible => true)
      page.has_xpath?("//div[@data-title='Use it!']", :visible => false)

      page.find(".next").click
      page.find(".closeButton").click
      page.has_xpath?("//div[@data-title='Get Ready...']", :visible => false)
      page.has_xpath?("//div[@data-title='Use it!']", :visible => false)
    end
  end
end

def create_channel(user)
  channel = FactoryGirl.create(:channel, created_by: user.graph_user)
  channel
end


describe "Walkthrough the app", type: :request do

  before :each do
    @user = make_user_and_login
  end

  describe "creating a Factlink" do
    it "should add a factlink", js:true do
      fact_name = "baronnenbillen"

      visit new_fact_path
      fill_in "fact", with: fact_name
      click_button "submit"
      page.should have_content "Factlink successfully posted"
      visit root_path
      page.should have_content "My Stream"
      page.should have_content fact_name
    end

    it "should be able to delete a factlink", js:true do
      fact_name = "raar"

      # create fact:
      visit new_fact_path
      fill_in "fact", with: fact_name
      click_button "submit"
      visit root_path
      page.should have_content fact_name

      # and delete it:
      page.evaluate_script('window.confirm = function() { return true; }')
      page.execute_script("$($('article.fact')[0]).parent().find('li.destroy').click()")

      page.should_not have_content fact_name
    end
  end

  describe "channels" do
    it "can be created", js: true do
      channel_title = "Teh hot channel"
      click_link "Add new"
      fill_in "channel_title", with: channel_title
      click_button "Create"

      within(:css, "h1") do
        page.should have_content(channel_title)
      end

      # Visiting the edit page and editing the page
      click_link "edit"
      channel_title_modified = "this is the corrected one"
      fill_in "channel_title", with: channel_title_modified
      click_button "Apply"

      within(:css, "h1") do
        page.should have_content(channel_title_modified)
      end

      click_link "edit"
      handle_js_confirm(accept=true) do
        click_link "Delete"
      end

      within(:css, "h1") do
        page.should_not have_content(channel_title_modified)
      end
    end

    it "can be visited", js: true do
      @channel = create_channel(@user)

      visit channel_path(@user, @channel)

      page.should have_content(@channel.title)
    end
  end

  describe "searching" do
    it "cannot find a something that does not exist", js:true do
      search_text = "searching for nothing and results for free"
      fill_in "factlink_search", with: search_text
      page.execute_script("$('#factlink_search').parent().submit()")
      page.should have_content("Sorry, your search didn't return any results.")
    end

    it "should find a just created factlink", js:true do
      # create factlink:
      visit new_fact_path
      fact_title = "fact to be found"
      fill_in "fact", with: fact_title
      click_button "submit"
      page.should have_content "Factlink successfully posted"

      # and search for it:
      visit root_path
      fill_in "factlink_search", with: fact_title
      page.execute_script("$('#factlink_search').parent().submit()")
      page.should have_content(fact_title)
    end
  end

  it "should be possible to reserve a username and this should result in a confirmation message"
end
