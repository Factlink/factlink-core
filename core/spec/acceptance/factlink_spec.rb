require 'acceptance_helper'

describe "factlink", type: :feature do
  include FactHelper
  include PavlovSupport
  include Acceptance::FactHelper
  include Acceptance::AuthenticationHelper
  include Acceptance::CommentHelper

  context "for logged in users" do
    before :each do
      @user = sign_in_user create :user, :confirmed
    end

    it "can be agreed" do
      @factlink = create :fact
      open_discussion_sidebar_for @factlink

      find('.spec-button-believes').click

      eventually_succeeds do
        as(@user) do |pavlov|
          expect(pavlov.interactor(:'facts/votes', fact_id: @factlink.id).length).to eq 1
        end
      end
    end

    it "should find a factlink when searching on a exact phrase containing small words" do
      displaystring = 'feathers is not a four letter groom betters'

      @factlink = create :fact

      @factlink_evidence = create :fact
      @factlink_evidence.data.displaystring = "Fact: " + displaystring
      @factlink_evidence.data.save

      open_discussion_sidebar_for @factlink
      add_existing_factlink @factlink_evidence
    end
  end

  it "a non logged user can log in now" do
    factlink = create :fact

    open_discussion_sidebar_for factlink

    fill_in_comment_textarea 'Some text to show Post button'
    click_button 'Post'

    page.should have_content 'sign in/up with email'
  end
end
