require 'acceptance_helper'

feature "sub_comments", type: :feature do
  include Acceptance
  include Acceptance::FactHelper
  include Pavlov::Helpers
  include Acceptance::CommentHelper

  scenario "A user can comment on a comment" do
    fact_data = create :fact_data
    user = create :user

    as(user) do |pavlov|
      pavlov.interactor(:'comments/create', fact_id: fact_data.fact_id, type: "believes", content: "test", pavlov_options: pavlov_options)
    end
    sub_comment_text = "Berlioz' death was predicted by the man with the pince-nez"

    switch_to_user(user)
    open_discussion_sidebar_for fact_data.fact_id

    click_link '(0) Reply'

    add_sub_comment(sub_comment_text)
    assert_sub_comment_exists sub_comment_text

    switch_to_user(create :user)

    open_discussion_sidebar_for fact_data.fact_id

    find_link('(1) Reply') #open by default, no need to click

    assert_sub_comment_exists sub_comment_text
  end
end
