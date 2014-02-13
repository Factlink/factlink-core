module Acceptance
  module CommentHelper
      def open_search_factlink
        return if all('.spec-open-search-facts-link').empty?

        page.find('.spec-open-search-facts-link').click
      end

      def add_comment comment
        within '.spec-add-comment-form' do
          comment_input = find('.text_area_view')
          comment_input.click

          comment_input = find('.text_area_view')
          comment_input.value.should eq ''
          comment_input.click
          comment_input.set comment
          comment_input.value.should eq comment

          click_button "Post"
        end

        wait_until_argument_has_one_vote comment
      end

      def add_existing_factlink evidence_factlink
        open_search_factlink

        text = evidence_factlink.to_s

        within '.spec-add-comment-form' do
          comment_input = find('.text_area_view')
          comment_input.click

          # Open search by entering something
          comment_input.set 'something'
          comment_input.set ''
          find('.spec-open-search-facts-link').click

          page.find("input[type=text]").click
          page.find("input[type=text]").set(text)
          page.find(".spec-fact-search-result", text: text).click

          click_button "Post"
        end

        wait_until_argument_has_one_vote text
      end

      def wait_until_argument_has_one_vote text
        page.find('.comment-container', text: text).find('.spec-evidence-relevance', text: 1)
      end

      def add_sub_comment(comment)
        find('.spec-sub-comments-form .text_area_view').set comment
        find('.spec-sub-comments-form .text_area_view').value.should eq comment
        within '.spec-sub-comments-form' do
          click_button 'Reply'
        end
        eventually_succeeds do
          find('.spec-sub-comments-form .text_area_view').value.should eq ''
        end
      end

      def assert_sub_comment_exists(comment)
        find('.spec-subcomment-content', text: comment)
      end

      def assert_comment_exists comment
        within_evidence_list do
          find('.spec-comment-content', text: comment)
        end
      end

      def within_evidence_list &block
        wait_until_evidence_list_loaded
        within '.evidence-container', visible: false, &block
      end

      def wait_until_evidence_list_loaded
        # this only shows after the discussion list has fully loaded
        find('.opinion-help, .spec-add-comment-form')
      end

      def vote_comment direction, comment
        within('.comment-container', text: comment, visible: false) do
          find(".spec-evidence-vote-#{direction}").click
        end
      end
  end
end
