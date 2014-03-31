require 'acceptance_helper'

describe "factlink", type: :feature do
  include ScreenshotTest
  include Acceptance::FactHelper
  include Acceptance::CommentHelper

  before do
    @user = sign_in_user create :user

    @factlink = backend_create_fact_with_long_text
    comment_text = "A comment...\n\n...with newlines!"

    as(@user) do |pavlov|
      pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.id, opinion: 'believes')
    end

    as(@user) do |p|
      c = p.interactor(:'comments/create', fact_id: @factlink.id.to_i, type: 'believes', content: comment_text)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'disbelieves')
    end

    supporting_factlink = backend_create_fact_with_long_text
    sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"

    as(@user) do |p|
      other_factlink = create :fact
      fact_url = FactUrl.new(other_factlink)
      c = p.interactor(:'comments/create', fact_id: @factlink.id.to_i, type: 'believes', content: fact_url.friendly_fact_url)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'believes')
      p.interactor(:'sub_comments/create', comment_id: c.id.to_s, content: "A short subcomment")
      p.interactor(:'sub_comments/create', comment_id: c.id.to_s, content: sub_comment_text)
    end
  end


  it "the layout of the new discussion page is correct with believers on top,
      and adding supporting factlink" do
    5.times do
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.id, opinion: 'believes')
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.id, opinion: 'disbelieves')
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.id, opinion: 'disbelieves')
      end
    end

    as(create :user) do |pavlov|
      pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.id, opinion: 'believes')
    end

    open_discussion_sidebar_for @factlink

    page.should have_content @factlink.data.displaystring

    find_link('(2) Reply').click

    find('.sub-comment + .sub-comment .icon-trash').click #open delete so it's tested too
    #implicitly, the previous line is also necessary to wait for the second subcomment to appear
    assume_unchanged_screenshot "fact_show"
  end

  it "the layout of the new discussion page is correct for an anonymous user" do
    sign_out_user

    open_discussion_sidebar_for @factlink
    find_link('(2) Reply').click
    find('.sub-comment+.sub-comment')

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
