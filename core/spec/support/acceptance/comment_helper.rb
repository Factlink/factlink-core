module Acceptance
  module CommentHelper
      def toggle_to_comment
        within add_evidence_form_css_selector do
          evidence_input = page.find_field 'text_input_view'
          evidence_input.trigger 'focus'

          page.find('.js-switch').set true
        end
      end

      def toggle_to_factlink
        within add_evidence_form_css_selector do
          page.find('.js-switch').set false
        end
      end

      def posting_factlink?
        within add_evidence_form_css_selector do
          page.find('input').click
          find('button').has_content? 'Post Factlink'
        end
      end

      def posting_comment?
        within add_evidence_form_css_selector do
          page.find('input').click
          find('button').has_content? 'Post Comment'
        end
      end

      def add_comment comment
        toggle_to_comment if posting_factlink? #unless posting_comment?

        within add_evidence_form_css_selector do
          comment_input = page.find_field 'add_comment'

          comment_input.trigger 'focus'
          comment_input.set comment
          comment_input.trigger 'blur'

          click_button 'Post comment'
        end
      end

      def add_existing_factlink evidence_factlink
        toggle_to_factlink unless posting_factlink?

        within add_evidence_form_css_selector do
          text = evidence_factlink.to_s
          page.find("input").set(text)
          page.find("li", text: text).click
          page.find("input", visible: false)
          page.find_button("Post Factlink").click

          wait_for_ajax
        end
      end

      def add_new_factlink text
        toggle_to_factlink unless posting_factlink?

        within add_evidence_form_css_selector do
          page.find("input").set(text)
          page.find_button("Post Factlink").click
        end
      end

      def add_sub_comment(comment)
        fill_in 'text_area_view', with: comment
        sleep 0.5 # To allow for the getting bigger CSS animation
        find('.evidence-sub-comments-button', text: 'Comment').click
        sleep 0.5 # To allow for the getting smaller CSS animation
      end

      def assert_sub_comment_exists(comment)
        find('.evidence-sub-comment-content', text: comment)
      end

      def add_evidence_form_css_selector
        '.fact-relation-search'
      end

      def js_displaystring_css_selector
        ".js-displaystring"
      end

      def evidence_item_css_selector
        '.evidence-item'
      end

      def evidence_listing_css_selector
        '.fact-relation-listing'
      end

      def js_content_css_selector
        '.js-content'
      end
  end
end
