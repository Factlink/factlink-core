require 'integration_helper'

feature "adding comments to a fact", type: :request do
  include Acceptance::FactHelper
  include Acceptance::CommentHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user create :approved_confirmed_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "after adding a comment it should show up and persist" do

    go_to_discussion_page_of factlink

    comment = 'Geert is een buffel'
    add_comment comment

    # Input should be empty
    find_field('add_comment').value.blank?.should be_true

    evidence_listing.should have_content comment

    go_to_discussion_page_of factlink # Reload the page

    evidence_listing.should have_content comment

  end


  scenario 'after adding a comment it should have brain cycles' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    go_to_discussion_page_of factlink

    within evidence_listing do
      find('.total-authority-evidence').should have_content user_authority_on_fact + 1
    end
  end

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    within evidence_listing do
      evidence_item(comment).find('.supporting').click
      evidence_item(comment).find('.total-authority-evidence', text: "0.0")
    end

    go_to_discussion_page_of factlink

    within evidence_listing do
      find('.total-authority-evidence', text: "0.0")
    end
  end

  scenario "after adding multiple comments they should show up and persist" do
    go_to_discussion_page_of factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment comment1
    add_comment comment2

    evidence_listing.should have_content comment1
    evidence_listing.should have_content comment2

    go_to_discussion_page_of factlink # Reload the page

    evidence_listing.should have_content comment1
    evidence_listing.should have_content comment2
  end


  scenario "after adding it can be removed" do
    go_to_discussion_page_of factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment comment

    within evidence_listing do
      find('.evidence-popover-arrow').click
      find('.delete').click
      wait_for_ajax
    end

    page.should_not have_content comment

    go_to_discussion_page_of factlink

    page.should_not have_content comment
  end

  def evidence_item text
    find '.evidence-item', text: text
  end

  def evidence_listing
    find '.fact-relation-listing'
  end
end
