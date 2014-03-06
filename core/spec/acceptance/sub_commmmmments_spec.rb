require 'acceptance_helper'

feature "sub_comments", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Pavlov::Helpers
  include Acceptance::CommentHelper

  background do
    @user_a = sign_in_user create :user, :confirmed
    @user_b = create :user, :confirmed

    @factlink_user_a = create :fact
  end

  scenario "A user can comment on a comment" do
    @comment_user_b = command(:'comments/create', fact_id: @factlink_user_a.id.to_i, type: "believes", content: "test", user_id: @user_b.id.to_s)

    sub_comment_text = "Berlioz' death was predicted by the man with the pince-nez"

    open_discussion_sidebar_for @factlink_user_a

    click_link '(0) Reply'

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text

    switch_to_user(@user_b)

    open_discussion_sidebar_for @factlink_user_a

    click_link '(1) Reply'
    assert_sub_comment_exists sub_comment_text
  end

  scenario "After adding a subcomment the evidence can not be removed any more" do
    pending
    @fact_relation_user_b = create :fact
    @factlink_user_a.add_evidence("believes", @fact_relation_user_b, @user_a)

    sub_comment_text = "Sub Comment 1"

    open_discussion_sidebar_for @factlink_user_a

    page.should have_selector('.spec-evidence-box .delete-button-first')

    click_link 'Reply'

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text


    page.should have_no_selector('.spec-evidence-box .delete-button-first')

    open_discussion_sidebar_for @factlink_user_a

    page.should have_no_selector('.spec-evidence-box .delete-button-first')
  end
end
