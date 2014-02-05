require 'acceptance_helper'

describe "factlink", type: :feature, driver: :poltergeist_slow do
  include ScreenshotTest
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  before do
    @user = sign_in_user create :full_user

    @factlink = backend_create_fact_with_long_text
    comment_text = "A comment...\n\n...with newlines!"

    @factlink.add_opiniated :believes, @user.graph_user
    as(@user) do |p|
      c = p.interactor(:'comments/create', fact_id: @factlink.id.to_i, type: 'believes', content: comment_text)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'disbelieves')
    end

    supporting_factlink = backend_create_fact_with_long_text
    supporting_factlink.add_opiniated :believes, @user.graph_user
    sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"

    as(@user) do |p|
      other_factlink = backend_create_fact
      fact_url = FactUrl.new(other_factlink)
      c = p.interactor(:'comments/create', fact_id: @factlink.id.to_i, type: 'believes', content: fact_url.friendly_fact_url)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'believes')
      p.interactor(:'sub_comments/create_for_comment', comment_id: c.id.to_s, content: "A short subcomment")
      p.interactor(:'sub_comments/create_for_comment', comment_id: c.id.to_s, content: sub_comment_text)
    end
  end


  it "the layout of the new discussion page is correct with believers on top,
      and adding supporting factlink" do
    5.times do
      @factlink.add_opiniated :disbelieves, (create :user).graph_user
      @factlink.add_opiniated :believes, (create :user).graph_user
      @factlink.add_opiniated :believes, (create :user).graph_user
    end

    @factlink.add_opiniated :believes, (create :user).graph_user

    go_to_fact_show_of @factlink

    page.should have_content @factlink.data.displaystring

    first('.spec-sub-comments-link').click
    first('.sub-comment-container') # wait for subcomments to appear

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
