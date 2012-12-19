module Acceptance
  module CommentHelper

      def toggle_to_comment
        within add_evidence_form do
          evidence_input = page.find_field 'text_input_view'
          evidence_input.trigger 'focus'
          page.find('.js-switch').set true
        end
      end

      def toggle_to_factlink
        within add_evidence_form do
          page.find('.js-switch').set false
        end
      end

      def posting_factlink?
        find('button').has_content? 'Post Factlink'
      end

      def posting_comment?
        find('button').has_content? 'Post Comment'
      end

      def add_comment comment
        toggle_to_comment if posting_factlink? #unless posting_comment?
        within add_evidence_form do
          comment_input = page.find_field 'add_comment'

          comment_input.trigger 'focus'
          comment_input.set comment
          comment_input.trigger 'blur'

          click_button 'Post comment'
          wait_for_ajax
        end
      end

      def add_existing_factlink evidence_factlink
        toggle_to_factlink unless posting_factlink?
        within add_evidence_form do
          text = evidence_factlink.to_s
          page.find("input").set(text)
          page.find("li", text: text).click
          page.find("input", visible: false)
          page.find_button("Post Factlink").click
        end
      end

      def add_new_factlink text
        within add_evidence_form do
          toggle_to_factlink unless posting_factlink?
          page.find("input").set(text)
          page.find_button("Post Factlink").click
        end
      end

      def add_evidence_form
        find('.fact-relation-search')
      end

      def evidence_item text
        find '.evidence-item', text: text
      end

      def evidence_listing
        find '.fact-relation-listing'
      end

  end
end
