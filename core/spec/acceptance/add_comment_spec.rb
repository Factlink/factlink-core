require 'acceptance_helper'

# TODO rename to add_evidence_spec
feature "adding comments to a fact", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Acceptance::CommentHelper
  include Acceptance::AddToChannelModalHelper

  background do
    @user = sign_in_user create :full_user, :confirmed
  end

  let(:factlink) { create :fact, created_by: @user.graph_user }

  scenario "after adding a comment it should show up and persist" do

    go_to_discussion_page_of factlink

    comment = 'Geert is een buffel'
    add_comment :supporting, comment

    assert_comment_exists comment

    go_to_discussion_page_of factlink # Reload the page

    assert_comment_exists comment
  end

  scenario 'after adding a comment it should have brain cycles' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment :supporting, comment
    assert_comment_exists comment

    go_to_discussion_page_of factlink

    within_evidence_list do
      find('.evidence-impact-text').should have_content user_authority_on_fact + 1
    end
  end

  scenario 'after adding a comment, the user should be able to reset his opinion' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment = 'Buffels zijn niet klein te krijgen joh'
    add_comment :supporting, comment
    assert_comment_exists comment

    within_evidence_list do
      # there is just one factlink in the list
      find('.evidence-impact-text', text: (user_authority_on_fact+1).to_s)
      find('.evidence-impact-vote-up').click
      find('.evidence-impact-text', text: "0.0")
    end

    go_to_discussion_page_of factlink

    within_evidence_list do
      find('.evidence-impact-text', text: "0.0")
    end
  end

  scenario "after adding multiple comments they should show up and persist" do
    go_to_discussion_page_of factlink

    comment1 = 'Vroeger was Gerard een hengst'
    comment2 = 'Henk is nog steeds een buffel'

    add_comment :supporting, comment1
    add_comment :supporting, comment2

    assert_comment_exists comment1
    assert_comment_exists comment2

    go_to_discussion_page_of factlink # Reload the page

    assert_comment_exists comment1
    assert_comment_exists comment2
  end

  scenario 'comments and facts should be sorted on relevance' do
    user_authority_on_fact = 17
    Authority.on( factlink, for: @user.graph_user ) << user_authority_on_fact

    go_to_discussion_page_of factlink

    comment1 = 'Buffels zijn niet klein te krijgen joh'
    factlink2 = backend_create_fact
    comment3 = 'Geert is een baas'

    add_comment :supporting, comment1
    add_existing_factlink :supporting, factlink2
    add_comment :supporting, comment3

    # make sure sorting is done:
    sleep 1

    vote_comment :down, comment1
    vote_comment :up  , comment3

    go_to_discussion_page_of factlink

    #find text with comment - we need to do this before asserting on ordering
    #since expect..to..match is not async, and at this point the comment ajax
    #may not have been completed yet.
    assert_comment_exists comment1

    within_evidence_list do
      items = all '.evidence-votable', visible: false
      expect(items[0].text).to match (Regexp.new factlink2.to_s)
      expect(items[1].text).to match (Regexp.new comment3)
      expect(items[2].text).to match (Regexp.new comment1)
    end
  end

  scenario "after adding it can be removed" do
    go_to_discussion_page_of factlink

    comment = 'Vroeger had Gerard een hele stoere fiets'

    add_comment :supporting, comment
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
