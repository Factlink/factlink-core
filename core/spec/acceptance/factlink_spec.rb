require 'acceptance_helper'

describe "factlink", type: :feature do
  include FactHelper
  include Acceptance::FactHelper
  include Acceptance::AuthenticationHelper
  include Acceptance::CommentHelper

  context "for logged in users" do
    before :each do
      @user = sign_in_user create :full_user
    end

    it "can be agreed" do
      @factlink = backend_create_fact_of_user @user
      search_string = 'Test search'

      go_to_discussion_page_of @factlink

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
      @factlink = backend_create_fact_of_user @user
      search_string = 'Test search'

      go_to_discussion_page_of @factlink

      page.should have_content(@factlink.data.title)

      neutral_path_position = 1

      old_neutral_path_opacity = wheel_path_opacity neutral_path_position
      old_neutral_path_shape = wheel_path_d neutral_path_position

      click_wheel_part neutral_path_position
      eventually_succeeds do
        old_neutral_path_opacity.should_not eq wheel_path_opacity neutral_path_position
        old_neutral_path_shape.should eq wheel_path_d neutral_path_position
      end
    end

    it "can be disagreed" do
      @factlink = backend_create_fact_of_user @user
      search_string = 'Test search'

      go_to_discussion_page_of @factlink

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

      @factlink = backend_create_fact_of_user @user

      @factlink_evidence = backend_create_fact_of_user @user
      @factlink_evidence.data.displaystring = "Fact: " + displaystring
      @factlink_evidence.data.save

      go_to_discussion_page_of @factlink
      page.should have_content(@factlink.data.title)

      add_existing_factlink :supporting, displaystring
    end
  end

  it "a non logged in user gets redirected to the login page when accessing the discussionpage" do
    user = create :full_user
    factlink = backend_create_fact_of_user user

    visit friendly_fact_path(factlink)

    assert_on_login_page
  end


end
