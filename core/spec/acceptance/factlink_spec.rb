require 'acceptance_helper'

describe "factlink", type: :feature do
  include FactHelper
  include Acceptance::FactHelper
  include Acceptance::AuthenticationHelper

  context "for logged in users" do
    before :each do
      @user = sign_in_user create :active_user
    end

    it "evidence can be added" do
      @factlink = create_factlink @user
      search_string = 'Test search'

      visit friendly_fact_path(@factlink)

      page.should have_content(@factlink.data.title)

      within '.auto-complete-fact-relations' do
        input = page.find(:css, 'input')
        input.set(search_string)
        input.trigger('focus')
      end

      page.should have_selector(".auto-complete-search-list-container")

      page.find('.fact-relation-post').click

      page.should have_selector('li.evidence-item')
      within(:css, 'li.evidence-item') do
        page.should have_content search_string
      end
    end

    it "can be agreed" do
      @factlink = create_factlink @user
      search_string = 'Test search'

      visit friendly_fact_path(@factlink)

      page.should have_content(@factlink.data.title)

      agreed_path_position = 0

      old_agreed_path_opacity = wheel_path_opacity agreed_path_position
      old_agreed_path_shape = wheel_path_d agreed_path_position

      click_wheel_part agreed_path_position

      eventually_succeeds do
        old_agreed_path_opacity.should_not eq wheel_path_opacity agreed_path_position
        old_agreed_path_shape.should_not eq wheel_path_d agreed_path_position
      end
    end

    it "can be neutraled" do
      @factlink = create_factlink @user
      search_string = 'Test search'

      visit friendly_fact_path(@factlink)

      page.should have_content(@factlink.data.title)

      neutral_path_position = 1

      old_neutral_path_opacity = wheel_path_opacity neutral_path_position
      old_neutral_path_shape = wheel_path_d neutral_path_position

      click_wheel_part neutral_path_position

      old_neutral_path_opacity.should_not eq wheel_path_opacity neutral_path_position
      old_neutral_path_shape.should eq wheel_path_d neutral_path_position
    end

    it "can be disagreed" do
      @factlink = create_factlink @user
      search_string = 'Test search'

      visit friendly_fact_path(@factlink)

      page.should have_content(@factlink.data.title)

      disagreed_path_position = 2

      old_disagreed_path_opacity = wheel_path_opacity disagreed_path_position
      old_disagreed_path_shape = wheel_path_d disagreed_path_position

      click_wheel_part disagreed_path_position

      eventually_succeeds do
        old_disagreed_path_opacity.should_not eq wheel_path_opacity disagreed_path_position
        old_disagreed_path_shape.should_not eq wheel_path_d disagreed_path_position
      end
    end

    it "should find a factlink when searching on a exact phrase containing small words" do
      displaystring = 'feathers is not a four letter groom betters'

      @factlink = create_factlink @user

      @factlink_evidence = create_factlink @user
      @factlink_evidence.data.displaystring = "Fact: " + displaystring
      @factlink_evidence.data.save

      visit friendly_fact_path(@factlink)
      page.should have_content(@factlink.data.title)

      within '.fact-relation-search' do
        fill_in 'text_input_view', with: displaystring
      end

      within '.auto-complete-search-list' do
        page.should have_content @factlink_evidence.data.displaystring
      end
    end
  end

  it "a non logged in user gets redirected to the login page when accessing the discussionpage" do
    user = create :active_user
    factlink = create_factlink user

    visit friendly_fact_path(factlink)

    assert_on_login_page
  end


end
