require 'acceptance_helper'

describe "factlink", type: :feature do
  include FactHelper
  include Acceptance::FactHelper
  include Acceptance::AuthenticationHelper
  include Acceptance::CommentHelper

  context "for logged in users" do
    before :each do
      @user = sign_in_user create :full_user, :confirmed
    end

    it "can be agreed" do
      @factlink = backend_create_fact_of_user @user
      search_string = 'Test search'

      go_to_discussion_page_of @factlink

      page.should have_content(@factlink.data.title)

      click_agree

      eventually_succeeds do
        expect(@factlink.believable.opinion_of_graph_user(@user.graph_user)).to eq "believes"
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

      add_existing_factlink :believes, displaystring
    end
  end

  it "a non logged user can log in now" do
    user = create :full_user, :confirmed
    factlink = backend_create_fact_of_user user

    visit friendly_fact_path(factlink)

    page.should have_content 'sign in/up with Factlink'
  end


end
