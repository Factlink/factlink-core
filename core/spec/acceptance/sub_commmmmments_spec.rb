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
    as(@user_b) do |p|
      @comment_user_b = p.interactor(:'comments/create', fact_id: @factlink_user_a.id.to_i, type: "believes", content: "test", pavlov_options: pavlov_options)
    end
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
end
