module Acceptance
  module CommentHelper

      def toggle_to_comment
        toggle_between_factlink_and_comment true
      end

      def toggle_to_factlink
        toggle_between_factlink_and_comment false
      end

      def toggle_between_factlink_and_comment(to_comment)
        within('.fact-relation-search') do
          evidence_input = page.find_field 'text_input_view'
          evidence_input.trigger 'focus'
          page.find('.js-switch').set to_comment
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
        within('.fact-relation-search') do
          comment_input = page.find_field 'add_comment'

          comment_input.trigger 'focus'
          comment_input.set comment
          comment_input.trigger 'blur'

          click_button 'Post comment'
          wait_for_ajax
        end
      end

      def add_factlink evidence_factlink
        toggle_to_factlink unless posting_factlink?
        text = evidence_factlink.to_s
        page.find("input").set(text)
        page.find("li", text: text).click
        page.find("input", visible: false)
        page.find_button("Post Factlink").click
      end
  end
end
