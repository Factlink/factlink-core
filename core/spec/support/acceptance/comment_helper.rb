module Acceptance
  module CommentHelper
      def open_search_factlink
        return if all('.js-open-search-facts-link').empty?

        page.find('.js-open-search-facts-link').click
      end

      # Doubts the factlink if not already given opinion, which opens
      # the comment box
      def open_add_comment_form
        return unless all('.add-evidence-form').empty?
        find('.spec-button-believes').click
        find('.add-evidence-form')
      end

      def add_comment comment
        open_add_comment_form

        within '.add-evidence-form' do
          comment_input = find('.text_area_view')
          comment_input.click

          #ensure button is enabled, i.e. doesn't say "posting":
          find('button', 'Post')

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
        open_add_comment_form
        open_search_factlink

        text = evidence_factlink.to_s

        within '.add-evidence-form' do
          comment_input = find('.text_area_view')
          comment_input.click

          #ensure button is enabled, i.e. doesn't say "posting":
          find('button', 'Post')

          # try to open search, if not already open
          begin
            open_search = find('.js-open-search-facts-link')
            open_search.click
          rescue
          end

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
        find('.opinion-help, .add-evidence-form')
      end

      def vote_comment direction, comment
        within('.comment-container', text: comment, visible: false) do
          find(".spec-evidence-vote-#{direction}").click
        end
      end
  end
end
