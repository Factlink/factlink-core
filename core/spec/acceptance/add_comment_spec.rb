require 'acceptance_helper'

# TODO rename to add_evidence_spec
feature "adding comments to a fact", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user create :active_user
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "after adding a comment it should show up and persist" do

    go_to_discussion_page_of factlink

    comment = 'Geert is een buffel'
    add_comment comment

    # Input should be empty
    find('.text_area_view').value.should eq ''

    find('.fact-relation-listing').should have_content comment

    go_to_discussion_page_of factlink # Reload the page

    find('.fact-relation-listing').should have_content comment
  end

  scenario 'after adding a comment it should have brain cycles' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    go_to_discussion_page_of factlink

    within '.fact-relation-listing' do
      find('.authorities-evidence').should have_content user_authority_on_fact + 1
    end
  end

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    within '.fact-relation-listing' do
      # there is just one factlink in the list
      find('.authorities-evidence', text: (user_authority_on_fact+1).to_s)
      find('.supporting').click
      find('.authorities-evidence', text: "0.0")
    end

    go_to_discussion_page_of factlink

    within '.fact-relation-listing' do
      find('.authorities-evidence', text: "0.0")
    end
  end

  scenario "after adding multiple comments they should show up and persist" do
    go_to_discussion_page_of factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment comment1
    add_comment comment2

    find('.fact-relation-listing').should have_content comment1
    find('.fact-relation-listing').should have_content comment2

    go_to_discussion_page_of factlink # Reload the page

    find('.fact-relation-listing').should have_content comment1
    find('.fact-relation-listing').should have_content comment2
  end

  scenario 'comments and facts should be sorted on relevance' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment1 = 'Buffels zijn niet klein te krijgen joh'
    factlink2 = 'Henk ook niet'
    comment3 = 'Geert is een baas'

    add_comment comment1
    add_new_factlink factlink2
    add_comment comment3

    # make sure sorting is done:
    sleep 1

    within('.fact-relation-listing .evidence-item', text: comment1) do
      find('.weakening').click
    end
    within('.fact-relation-listing .evidence-item', text: comment3) do
      find('.supporting').click
    end

    go_to_discussion_page_of factlink

    within '.fact-relation-listing' do
      #find text with comment - we need to do this before asserting on ordering
      #since expect..to..match is not async, and at this point the comment ajax
      #may not have been completed yet.
      find('.evidence-item', text: comment1)

      items = all '.evidence-item'
      expect(items[0].text).to match (Regexp.new factlink2)
      expect(items[1].text).to match (Regexp.new comment3)
      expect(items[2].text).to match (Regexp.new comment1)
    end
  end

  scenario "after adding it can be removed" do
    go_to_discussion_page_of factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment comment

    within '.fact-relation-listing' do
      find('.evidence-poparrow-arrow', visible:false).click
      find('.delete', visible:false).click
    end

    page.should_not have_content comment

    go_to_discussion_page_of factlink

    page.should_not have_content comment
  end

  scenario "factlink should show Arguments (1) on profile page" do
    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment

    visit user_path(@user)

    page.should have_content 'Arguments (1)'
  end

end
