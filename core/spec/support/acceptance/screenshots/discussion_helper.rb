module Screenshots
  module DiscussionHelper

    include Acceptance::FactHelper
    include Acceptance::CommentHelper

    def factlink
      @factlink ||= backend_create_fact
    end

    def create_discussion
      go_to_discussion_page_of factlink
      click_wheel_part 0

      comment1_text = '1. Comment'
      factlink2_text = '2. New Factlink. Which is long. Very' + ', very' * 50 + ' long...'
      factlink3 = backend_create_fact
      sub_comment_text = "\n\nThis is a subcomment\n\nwith some  whitespace \n\n"
      sub_comment_text_normalized = "This is a subcomment with some whitespace"

      add_comment comment1_text
      add_new_factlink factlink2_text
      add_existing_factlink factlink3

      # make sure sorting is done:
      sleep 1

      within('.fact-relation-listing .evidence-item', text: comment1_text) do
        find('.weakening').click

        find('a', text: 'Comments').click
        add_sub_comment(sub_comment_text)
        assert_sub_comment_exists sub_comment_text_normalized
      end

      within('.fact-relation-listing .evidence-item', text: factlink3.data.displaystring) do
        find('a', text: 'Comments').click
        add_sub_comment(sub_comment_text)
        assert_sub_comment_exists sub_comment_text_normalized
      end

      factlink
    end

  end
end
