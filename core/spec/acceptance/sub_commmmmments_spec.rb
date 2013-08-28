require 'acceptance_helper'

feature "sub_comments", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Pavlov::Helpers
  include Acceptance::CommentHelper

  background do
    @user_a = sign_in_user create :active_user
    @user_b = create :active_user

    @factlink_user_a = create :fact, created_by: @user_a.graph_user
  end

  scenario "A user can comment on a comment" do
    @comment_user_b = command(:'create_comment', fact_id: @factlink_user_a.id.to_i, type: "believes", content: "test", user_id: @user_b.id.to_s)

    sub_comment_text = "Sub Comment 1"

    go_to_discussion_page_of @factlink_user_a

    find('a', text: 'Comment').click

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text

    switch_to_user(@user_b)

    go_to_discussion_page_of @factlink_user_a

    find('a', text: '1 comment').click
    assert_sub_comment_exists sub_comment_text
  end

  scenario "A user can comment on a fact relation" do
    @fact_relation_user_b = create :fact, created_by: @user_b.graph_user
    @factlink_user_a.add_evidence("supporting", @fact_relation_user_b, @user_b)

    sub_comment_text = "Sub Comment 1"

    go_to_discussion_page_of @factlink_user_a

    find('a', text: 'Comment').click

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text

    switch_to_user(@user_b)
    go_to_discussion_page_of @factlink_user_a

    find('a', text: '1 comment').click
    find('.evidence-sub-comment-content').should have_content sub_comment_text
  end

  scenario "After adding a subcomment the evidence can not be removed any more" do
    @fact_relation_user_b = create :fact, created_by: @user_b.graph_user
    @factlink_user_a.add_evidence("supporting", @fact_relation_user_b, @user_a)

    sub_comment_text = "Sub Comment 1"

    go_to_discussion_page_of @factlink_user_a

    within '.fact-relation-listing' do
      page.should have_selector('.spec-ndp-evidence-box .delete-button-first')
    end

    find('a', text: 'Comment').click

    add_sub_comment(sub_comment_text)
    find('.evidence-sub-comment-content').should have_content sub_comment_text

    within '.fact-relation-listing' do
      page.should have_no_selector('.spec-ndp-evidence-box .delete-button-first')
    end

    go_to_discussion_page_of @factlink_user_a

    within '.fact-relation-listing' do
      page.should have_no_selector('.spec-ndp-evidence-box .delete-button-first')
    end
  end
end
