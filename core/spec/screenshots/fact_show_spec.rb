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
      pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.fact_id, opinion: 'believes')
    end

    as(@user) do |p|
      c = p.interactor(:'comments/create', fact_id: @factlink.fact_id, type: 'believes', content: comment_text)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'disbelieves')
    end

    supporting_factlink = backend_create_fact_with_long_text
    sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"

    as(@user) do |p|
      fact_data = create :fact_data
      friendly_fact_url = FactlinkUI::Application.config.core_url + "/f/#{fact_data.fact_id}"
      c = p.interactor(:'comments/create', fact_id: @factlink.fact_id, type: 'believes', content: friendly_fact_url)
      p.interactor(:'comments/update_opinion', comment_id: c.id.to_s, opinion: 'believes')
      p.interactor(:'sub_comments/create', comment_id: c.id.to_s, content: "A short subcomment")
      p.interactor(:'sub_comments/create', comment_id: c.id.to_s, content: sub_comment_text)
    end
  end


  it "the layout of the new discussion page is correct with believers on top,
      and adding supporting factlink" do
    3.times do
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.fact_id, opinion: 'believes')
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.fact_id, opinion: 'disbelieves')
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: @factlink.fact_id, opinion: 'disbelieves')
      end
    end

    open_discussion_sidebar_for @factlink.fact_id

    page.should have_content @factlink.displaystring

    find_link('(2) Reply') #open by default, no need to click

    find('.sub-comment + .sub-comment .icon-trash').click #open delete so it's tested too
    #implicitly, the previous line is also necessary to wait for the second subcomment to appear

    find('.discussion-menu-link').click #open menubar for screenshot test.
    assume_unchanged_screenshot "fact_show"
  end

  it "the layout of the new discussion page is correct for an anonymous user" do
    sign_out_user

    open_discussion_sidebar_for @factlink.fact_id
    find_link('(2) Reply') #open by default, no need to click
    find('.sub-comment+.sub-comment')

    page.should have_content @factlink.displaystring

    find('.spec-button-interesting').click #show sign-in overlay for screenshots
    assume_unchanged_screenshot "fact_show_for_non_signed_in_user"
  end
end
