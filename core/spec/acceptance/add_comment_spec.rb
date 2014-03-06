require 'acceptance_helper'

# TODO rename to add_evidence_spec
feature "adding comments to a fact", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  background do
    @user = sign_in_user create :user, :confirmed
  end

  let(:factlink) { create :fact }

  scenario "after adding a comment it should show up and persist" do

    open_discussion_sidebar_for factlink

    comment = "The tomcat hopped on the bus after Berlioz' death"
    add_comment comment

    assert_comment_exists comment

    open_discussion_sidebar_for factlink # Reload the page

    assert_comment_exists comment
  end

  scenario 'after adding a comment it has one upvote' do
    open_discussion_sidebar_for factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment
    assert_comment_exists comment

    open_discussion_sidebar_for factlink

    find('.spec-comment-vote-amount').should have_content 1
  end

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    open_discussion_sidebar_for factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment comment
    assert_comment_exists comment

    # there is just one factlink in the list
    find('.spec-comment-vote-amount', text: "1")
    find('.spec-comment-vote-up').click
    find('.spec-comment-vote-amount', text: "0")

    open_discussion_sidebar_for factlink

    find('.spec-comment-vote-amount', text: "0")
  end

  scenario "after adding multiple comments they should show up and persist" do
    open_discussion_sidebar_for factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment comment1
    add_comment comment2

    assert_comment_exists comment1
    assert_comment_exists comment2

    open_discussion_sidebar_for factlink # Reload the page

    assert_comment_exists comment1
    assert_comment_exists comment2
  end

  scenario 'comments and comments with links to annotations should be sorted on relevance' do
    open_discussion_sidebar_for factlink

    comment1 = 'Buffels zijn niet klein te krijgen joh'
    factlink2 = create :fact
    comment3 = 'Geert is een baas'

    add_comment comment1
    add_existing_factlink factlink2
    add_comment comment3

    vote_comment :down, comment1
    vote_comment :up  , comment3

    open_discussion_sidebar_for factlink

    #find text with comment - we need to do this before asserting on ordering
    #since expect..to..match is not async, and at this point the comment ajax
    #may not have been completed yet.
    assert_comment_exists comment1

    items = all '.spec-evidence-box'
    expect(items[0].text).to match (Regexp.new factlink2.to_s)
    expect(items[1].text).to match (Regexp.new comment3)
    expect(items[2].text).to match (Regexp.new comment1)
  end

  scenario "after adding it can be removed" do
    open_discussion_sidebar_for factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment comment
    assert_comment_exists comment

    find('.spec-evidence-box .delete-button-first').click
    find('.spec-evidence-box .delete-button-second').click

    page.should_not have_content comment

    open_discussion_sidebar_for factlink

    page.should_not have_content comment
  end
end
