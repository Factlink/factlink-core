require 'acceptance_helper'

# TODO rename to add_evidence_spec
feature "adding comments to a fact", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  background do
    @user = sign_in_user create :full_user, :confirmed
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "after adding a comment it should show up and persist" do

    go_to_discussion_page_of factlink

    comment = "The tomcat hopped on the bus after Berlioz' death"
    add_comment comment

    assert_comment_exists comment

    go_to_discussion_page_of factlink # Reload the page

    assert_comment_exists comment
  end

  scenario 'after adding a comment it has one upvote' do
    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment
    assert_comment_exists comment

    go_to_discussion_page_of factlink

    within_evidence_list do
      find('.spec-evidence-relevance').should have_content 1
    end
  end

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment
    assert_comment_exists comment

    within_evidence_list do
      # there is just one factlink in the list
      find('.spec-evidence-relevance', text: "1")
      find('.spec-evidence-vote-up').click
      find('.spec-evidence-relevance', text: "0")
    end

    go_to_discussion_page_of factlink

    within_evidence_list do
      find('.spec-evidence-relevance', text: "0")
    end
  end

  scenario "after adding multiple comments they should show up and persist" do
    go_to_discussion_page_of factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment comment1
    add_comment comment2

    assert_comment_exists comment1
    assert_comment_exists comment2

    go_to_discussion_page_of factlink # Reload the page

    assert_comment_exists comment1
    assert_comment_exists comment2
  end

  scenario 'comments and comments with links to annotations should be sorted on relevance' do
    go_to_discussion_page_of factlink

    comment1 = 'Buffels zijn niet klein te krijgen joh'
    factlink2 = backend_create_fact
    comment3 = 'Geert is een baas'

    add_comment comment1
    add_existing_factlink factlink2
    add_comment comment3

    vote_comment :down, comment1
    vote_comment :up  , comment3

    go_to_discussion_page_of factlink

    #find text with comment - we need to do this before asserting on ordering
    #since expect..to..match is not async, and at this point the comment ajax
    #may not have been completed yet.
    assert_comment_exists comment1

    within_evidence_list do
      items = all '.comment-region', visible: false
      expect(items[0].text).to match (Regexp.new factlink2.to_s)
      expect(items[1].text).to match (Regexp.new comment3)
      expect(items[2].text).to match (Regexp.new comment1)
    end
  end

  scenario "after adding it can be removed" do
    go_to_discussion_page_of factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment comment
    assert_comment_exists comment

    within_evidence_list do
      find('.delete-button-first').click
      find('.delete-button-second').click
    end

    page.should_not have_content comment

    go_to_discussion_page_of factlink

    page.should_not have_content comment
  end
end
