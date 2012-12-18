module Acceptance
  module CommentHelper

      def toggle_to_comment
        within('.fact-relation-search') do
          evidence_input = page.find_field 'text_input_view'
          evidence_input.trigger 'focus'
          page.find('.js-switch').set(true)
        end
      end

      def add_comment comment
        if find('button').has_content? 'Post Factlink'
          toggle_to_comment
        end
        within('.fact-relation-search') do
          comment_input = page.find_field 'add_comment'

          comment_input.trigger 'focus'
          comment_input.set comment
          comment_input.trigger 'blur'

          click_button 'Post comment'
          wait_for_ajax
        end
      end

      def add_evidence evidence_factlink
        text = evidence_factlink.to_s
        page.find("input").set(text)
        page.find("li", text: text).click
        page.find("input", visible: false)
        page.find_button("Post Factlink").click
      end
  end
end
