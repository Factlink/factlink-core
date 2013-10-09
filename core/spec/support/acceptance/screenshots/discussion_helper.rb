module Screenshots
  module DiscussionHelper

    include Acceptance::FactHelper
    include Acceptance::CommentHelper

    def factlink
      @factlink ||= backend_create_fact
    end

    def create_discussion
      comment_text = '1. Comment'

      sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"
      sub_comment_text_normalized = "This is a subcomment with some whitespace"

      supporting_factlink = backend_create_fact
      go_to_discussion_page_of supporting_factlink
      click_wheel_part 0

      go_to_discussion_page_of factlink
      click_wheel_part 0

      add_comment :supporting, comment_text
      add_existing_factlink :supporting, supporting_factlink

      # make sure sorting is done:
      sleep 1

      vote_comment :down, comment_text

      within('.evidence-votable', text: comment_text, visible: false) do
        find('a', text: 'Comment').click
        add_sub_comment(sub_comment_text)
        assert_sub_comment_exists sub_comment_text_normalized
      end

      within('.evidence-votable', text: supporting_factlink.data.displaystring, visible: false) do
        find('.js-down').click
        find('.spec-fact-disbelieve').click
        eventually_succeeds do
          find('a', text: 'Comment').click
          find('.spec-sub-comments-form').should_not eq nil
        end
        add_sub_comment(sub_comment_text)
        assert_sub_comment_exists sub_comment_text_normalized
      end

      factlink
    end

  end
end
