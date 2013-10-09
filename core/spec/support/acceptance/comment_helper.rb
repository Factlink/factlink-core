module Acceptance
  module CommentHelper
      def toggle_to_comment
        within '.add-evidence-form' do
          page.find('.js-switch-to-factlink').click
        end
      end

      def toggle_to_factlink
        within '.add-evidence-form' do
          page.find('.js-switch-to-factlink').click
        end
      end


      def posting_factlink?
        find('.add-evidence-form input[type=text],
              .add-evidence-form .text_area_view')[:placeholder].include? 'Factlink'
      end

      def posting_comment?
        find('.add-evidence-form input[type=text],
              .add-evidence-form .text_area_view')[:placeholder].include? 'Comment'
      end

      def open_add_type type
        find(".evidence-add-buttons .js-#{type}-button").click
      end

      def add_comment type, comment
        open_add_type type
        toggle_to_comment if posting_factlink? #unless posting_comment?

        within '.add-evidence-form' do
          comment_input = find('.text_area_view')

          comment_input.click
          #ensure button is enabled, i.e. doesn't say "posting":
          find('button', 'Post Comment')
          comment_input.set comment
          comment_input.value.should eq comment
          sleep 0.5 # To allow for the getting bigger CSS animation
          click_button "Post comment"
        end

        wait_until_add_buttons_appear
      end

      def add_existing_factlink type, evidence_factlink
        open_add_type type
        toggle_to_factlink unless posting_factlink?

        within '.add-evidence-form' do
          text = evidence_factlink.to_s
          page.find("input[type=text]").click
          page.find("input[type=text]").set(text)
          page.find("li", text: text).click
        end
        wait_until_add_buttons_appear
      end

      def add_new_factlink type, text
        open_add_type type
        toggle_to_factlink unless posting_factlink?

        within '.add-evidence-form' do
          page.find("input[type=text]").set(text)
          page.find("button", text: "Post Factlink").click
        end
        wait_until_add_buttons_appear
      end

      def wait_until_add_buttons_appear
        page.find('.js-supporting-button')
      end

      def add_sub_comment(comment)
        find('.spec-sub-comments-form .text_area_view').set comment
        find('.spec-sub-comments-form .text_area_view').value.should eq comment
        eventually_succeeds do
          if find('.spec-sub-comments-form .text_area_view').value != ''
            within '.spec-sub-comments-form' do
              click_button 'Post comment'
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
        # the add region only shows after the discussion list has fully loaded
        find('.js-add-region .evidence-add-supporting')
      end

      def vote_comment direction, comment
        within('.evidence-votable', text: comment, visible: false) do
          find(".evidence-impact-vote-#{direction}").click
        end
      end
  end
end
