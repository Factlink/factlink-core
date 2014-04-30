require 'acceptance_helper'

describe "factlink", type: :feature do
  include PavlovSupport
  include Acceptance::FactHelper
  include Acceptance::AuthenticationHelper
  include Acceptance::CommentHelper

  context "for logged in users" do
    before :each do
      @user = sign_in_user create :user, :confirmed
    end

    it "can be agreed" do
      @factlink = create :fact_data
      open_discussion_sidebar_for @factlink.fact_id.to_s

      find('.spec-button-interesting').click

      eventually_succeeds do
        as(@user) do |pavlov|
          expect(pavlov.interactor(:'facts/votes', fact_id: @factlink.fact_id.to_s).length).to eq 1
        end
      end
    end

    it "should find a factlink when searching on a exact phrase containing small words" do
      displaystring = 'feathers is not a four letter groom betters'

      @factlink = create :fact_data

      @factlink_evidence = create :fact_data, displaystring: "Fact: " + displaystring

      open_discussion_sidebar_for @factlink.fact_id.to_s
      add_existing_factlink @factlink_evidence.displaystring
    end
  end

  it "a non logged user can log in now" do
    factlink = create :fact_data

    open_discussion_sidebar_for factlink.fact_id.to_s

    fill_in_comment_textarea 'Some text to show Post button'
    click_button 'Post'

    page.should have_content 'sign in/up with email'
  end
end
