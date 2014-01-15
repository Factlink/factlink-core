require 'screenshot_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  before do
    @user = sign_in_user create :full_user

    @factlink = backend_create_fact_with_long_text
    comment_text = '1. Comment'

    sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"
    sub_comment_text_normalized = "This is a subcomment with some whitespace"

    @factlink.add_opiniated :believes, @user.graph_user
    as(@user) do |p|
      c = p.interactor(:'comments/create', fact_id: @factlink.id.to_i, type: 'doubts', content: comment_text)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'disbelieves')
      p.interactor(:'sub_comments/create_for_comment', comment_id: c.id.to_s, content: sub_comment_text)
    end

    supporting_factlink = backend_create_fact_with_long_text
    supporting_factlink.add_opiniated :believes, @user.graph_user

    fact_relation = @factlink.add_evidence('believes', supporting_factlink, @user)
    fact_relation.add_opinion(:believes, @user.graph_user)

    as(@user) do |p|
      p.interactor(:'sub_comments/create_for_fact_relation', fact_relation_id: fact_relation.id.to_i, content: sub_comment_text)
    end
  end


  it "the layout of the new discussion page is correct with believers on top,
      and adding supporting factlink" do
    5.times do
      @factlink.add_opiniated :disbelieves, (create :user).graph_user
      @factlink.add_opiniated :believes, (create :user).graph_user
      @factlink.add_opiniated :doubts, (create :user).graph_user
    end

    @factlink.add_opiniated :believes, (create :user).graph_user

    go_to_fact_show_of @factlink

    page.should have_content @factlink.data.displaystring

    first('.js-sub-comments-link').click

    assume_unchanged_screenshot "fact_show"
  end

  it "the layout of the new discussion page is correct for an anonymous user" do
    sign_out_user

    go_to_fact_show_of @factlink
    first('a', text: '1 comment')

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
