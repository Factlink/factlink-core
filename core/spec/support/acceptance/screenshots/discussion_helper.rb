module Screenshots
  module DiscussionHelper

    include Acceptance::FactHelper
    include Acceptance::CommentHelper

    def factlink
      @factlink ||= backend_create_fact
    end

    def create_discussion
      comment1_text = '1. Comment'
      factlink2_text = '2. New Factlink. Which is long. Very' + ', very' * 50 + ' long...'

      sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"
      sub_comment_text_normalized = "This is a subcomment with some whitespace"

      factlink3 = backend_create_fact
      go_to_discussion_page_of factlink3
      click_wheel_part 0

      go_to_discussion_page_of factlink
      click_wheel_part 0

      add_comment :supporting, comment1_text
      add_new_factlink :supporting, factlink2_text
      add_existing_factlink :supporting, factlink3

      # make sure sorting is done:
      sleep 1

      vote_comment :down, comment1_text

      within('.evidence-votable', text: comment1_text, visible: false) do
        find('a', text: 'Comment').click
        add_sub_comment(sub_comment_text)
        assert_sub_comment_exists sub_comment_text_normalized
      end

      within('.evidence-votable', text: factlink3.data.displaystring, visible: false) do
        find('.js-down').click
        find('.js-fact-disbelieve').click
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
