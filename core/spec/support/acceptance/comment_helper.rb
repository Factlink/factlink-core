module Acceptance
  module CommentHelper

      def add_comment_with_toggle comment
        evidence_input = page.find_field 'text_input_view'

        evidence_input.trigger 'focus'
        evidence_input.set comment
        evidence_input.trigger 'blur'

        page.find('.js-switch').set(true)

        click_button 'Post comment'
        wait_for_ajax
      end


      def add_comment comment
        comment_input = page.find_field 'add_comment'

        comment_input.trigger 'focus'
        comment_input.set comment
        comment_input.trigger 'blur'

        click_button 'Post comment'
        wait_for_ajax
      end

  end
end
