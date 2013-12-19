module Acceptance
  module CommentHelper
      def toggle_to_comment
        return if all('.add-evidence-form .js-switch-to-comment').empty?

        page.find('.add-evidence-form .js-switch-to-comment').click
      end

      def toggle_to_factlink
        return if all('.add-evidence-form .js-switch-to-factlink').empty?

        page.find('.add-evidence-form .js-switch-to-factlink').click
      end

      def select_add_type type
        find('.spec-evidence-radio-' + type.to_s).click
      end

      # Doubts the factlink if not already given opinion, which opens
      # the comment box
      def open_add_comment_form
        return unless all('.add-evidence-form').empty?

        click_button 'Unsure'
      end

      def add_comment type, comment
        open_add_comment_form
        toggle_to_comment

        within '.add-evidence-form' do
          select_add_type type

          comment_input = find('.text_area_view')

          comment_input.click
          #ensure button is enabled, i.e. doesn't say "posting":
          find('button', 'Post')
          comment_input.set comment
          comment_input.value.should eq comment
          sleep 0.5 # To allow for the getting bigger CSS animation
          click_button "Post"
        end

        wait_until_last_argument_has_one_vote
      end

      def add_existing_factlink type, evidence_factlink
        open_add_comment_form
        toggle_to_factlink

        within '.add-evidence-form' do
          select_add_type type

          text = evidence_factlink.to_s
          page.find("input[type=text]").click
          page.find("input[type=text]").set(text)
          page.find("li", text: text).click
        end

        wait_until_last_argument_has_one_vote
      end

      def wait_until_last_argument_has_one_vote
        within '.evidence-argument:last-child' do
          page.find('.spec-evidence-relevance', text: 1)
        end
      end

      def add_sub_comment(comment)
        find('.spec-sub-comments-form .text_area_view').set comment
        find('.spec-sub-comments-form .text_area_view').value.should eq comment
        eventually_succeeds do
          if find('.spec-sub-comments-form .text_area_view').value != ''
            within '.spec-sub-comments-form' do
              click_button 'Reply'
              find('.spec-sub-comments-form .text_area_view').value.should eq ''
            end
          end
        end
      end

      def assert_sub_comment_exists(comment)
        find('.sub-comment-container .discussion-evidenceish-text', text: comment)
      end

      def assert_comment_exists comment
        within_evidence_list do
          find('.discussion-evidenceish-text', text: comment)
        end
      end

      def within_evidence_list &block
        wait_until_evidence_list_loaded
        within '.evidence-listing', visible: false, &block
      end

      def wait_until_evidence_list_loaded
        # this only shows after the discussion list has fully loaded
        find('.opinion-help')
      end

      def vote_comment direction, comment
        within('.evidence-argument', text: comment, visible: false) do
          find(".spec-evidence-vote-#{direction}").click
        end
      end
  end
end
