require 'acceptance_helper'

feature "sub_comments", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Pavlov::Helpers
  include Acceptance::CommentHelper

  background do
    @user_a = sign_in_user create :full_user, :confirmed
    @user_b = create :full_user, :confirmed

    @factlink_user_a = create :fact, created_by: @user_a.graph_user
  end

  scenario "A user can comment on a comment" do
    @comment_user_b = command(:'create_comment', fact_id: @factlink_user_a.id.to_i, type: "believes", content: "test", user_id: @user_b.id.to_s)

    sub_comment_text = "Sub Comment 1"

    go_to_discussion_page_of @factlink_user_a

    click_link 'Comment'

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text

    switch_to_user(@user_b)

    go_to_discussion_page_of @factlink_user_a

    click_link '1 comment'
    assert_sub_comment_exists sub_comment_text
  end

  scenario "A user can comment on a fact relation" do
    @fact_relation_user_b = create :fact, created_by: @user_b.graph_user
    @factlink_user_a.add_evidence("supporting", @fact_relation_user_b, @user_b)

    sub_comment_text = "Sub Comment 1"

    go_to_discussion_page_of @factlink_user_a

    click_link 'Comment'

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text

    switch_to_user(@user_b)
    go_to_discussion_page_of @factlink_user_a

    click_link '1 comment'
    assert_sub_comment_exists sub_comment_text
  end

  scenario "After adding a subcomment the evidence can not be removed any more" do
    @fact_relation_user_b = create :fact, created_by: @user_b.graph_user
    @factlink_user_a.add_evidence("supporting", @fact_relation_user_b, @user_a)

    sub_comment_text = "Sub Comment 1"

    go_to_discussion_page_of @factlink_user_a

    within_evidence_list do
      page.should have_selector('.spec-evidence-box .delete-button-first')
    end

    click_link 'Comment'

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text


    within_evidence_list do
      page.should have_no_selector('.spec-evidence-box .delete-button-first')
    end

    go_to_discussion_page_of @factlink_user_a

    within_evidence_list do
      page.should have_no_selector('.spec-evidence-box .delete-button-first')
    end
  end
end
