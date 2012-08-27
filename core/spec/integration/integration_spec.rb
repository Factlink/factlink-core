def create_channel(user)
  channel = FactoryGirl.create(:channel, created_by: user.graph_user)
  channel
end

def create_factlink(user)
  FactoryGirl.create(:fact, created_by: user.graph_user)
end

describe "Walkthrough the app", type: :request do
  def created_channel_path(user)
    channel_path(user.username, user.graph_user.created_facts_channel.id)
  end

  before :each do
    @user = make_user_and_login
  end

  describe "creating a Factlink" do
    it "should add a factlink", js:true do
      fact_name = "baronnenbillen"

      visit new_fact_path
      fill_in "fact", with: fact_name
      click_button "submit"

      visit created_channel_path(@user)

      page.should have_content "My Stream"
      page.should have_content fact_name
    end

    it "should be able to delete a factlink", js:true do
      fact_name = "raar"

      # create fact:
      visit new_fact_path
      fill_in "fact", with: fact_name
      click_button "submit"

      visit created_channel_path(@user)

      page.should have_content fact_name

      # and delete it:
      page.evaluate_script('window.confirm = function() { return true; }')
      page.execute_script("$($('article.fact')[0]).parent().find('li.delete').click()")

      page.should_not have_content fact_name
    end
  end

  describe "factlinks" do
    pending "should be able to search for evidence", js:true do
      @factlink = create_factlink @user
      search_string = 'Test search'

      visit fact_path(@factlink)

      page.should have_content(@factlink.data.title)

      click_on "Supporting"

      fill_in 'supporting_search', :with => search_string

      sleep 1
      until page.evaluate_script('$.isReady && $.active===0') do
        sleep 1
      end

      page.should have_selector('.supporting li.add')

      page.execute_script('$(".supporting li.add").trigger("click")')

      sleep 10

      page.should have_selector('li.fact-relation')
      within(:css, 'li.fact-relation') do
        page.should have_content search_string
      end
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

      # and search for it:
      visit root_path
      fill_in "factlink_search", with: fact_title
      page.execute_script("$('#factlink_search').parent().submit()")
      page.should have_content(fact_title)
    end
  end

  it "should be possible to reserve a username and this should result in a confirmation message"
end
