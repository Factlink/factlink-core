module Acceptance
  module CommentHelper
      def toggle_to_comment
        within '.add-evidence-form' do
          page.find('.js-switch-to-factlink').set false
        end
      end

      def toggle_to_factlink
        within '.add-evidence-form' do
          page.find('.js-switch-to-factlink').set true
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

      def add_comment type, comment
        toggle_to_comment if posting_factlink? #unless posting_comment?

        within '.add-evidence-form' do
          comment_input = find('.text_area_view')

          comment_input.click
          #ensure button is enabled, i.e. doesn't say "posting":
          find('button', 'Post Comment')
          comment_input.set comment
          comment_input.value.should eq comment
          sleep 0.5 # To allow for the getting bigger CSS animation
          click_post_comment
          sleep 0.5 # To allow for the getting smaller CSS animation
        end
      end

      def add_existing_factlink evidence_factlink
        toggle_to_factlink unless posting_factlink?

        within '.add-evidence-form' do
          text = evidence_factlink.to_s
          page.find("input[type=text]").click
          page.find("input[type=text]").set(text)
          page.find("li", text: text).click
          potentially_wait_for_posting_button
          page.find("button", text: "Post Factlink")
        end
      end

      def add_new_factlink text
        toggle_to_factlink unless posting_factlink?

        within '.add-evidence-form' do
          page.find("input[type=text]").set(text)
          page.find("button", text: "Post Factlink").click
          potentially_wait_for_posting_button
          page.find("button", text: "Post Factlink")
        end
      end

      def potentially_wait_for_posting_button
        begin
          # We assume a request immediately fires, and button reads "Posting..."
          # This *should* hold:
            page.find("button", text: "Posting...")
          # ...but the posting delay vs. capybara check is a race-condition
          # so don't worry if this fails, at least then we're not continuing prematurely
        rescue
          puts "After clicking a button labelled 'Post', the button failed to change to 'Posting'."
          puts "This may be an error, indicating the button didn't react, or the test is wrong;"
          puts "however, it may just have finished and changed back to 'Post' too quickly to detect."
        end
      end

      def add_sub_comment(comment)
        # workaround for selenium focus: trigger focus; workaround for jquery: make sure there's
        # at least jquery-added handler first
        page.execute_script('$(".evidence-sub-comments-form .text_area_view").filter(function(){return this.value;}).on("focus",function(){})')
        page.execute_script('$(".evidence-sub-comments-form .text_area_view").filter(function(){return this.value;}).trigger("focus")')
        find('.evidence-sub-comments-form .text_area_view').set comment
        find('.evidence-sub-comments-form .text_area_view').value.should eq comment
        eventually_succeeds do
          if find('.evidence-sub-comments-form .text_area_view').value != ''
            find('.evidence-sub-comments-button', text: 'Post comment').click
            find('.evidence-sub-comments-form .text_area_view').value.should eq ''
          end
        end
      end

      def click_post_comment
        page.find("button", text: "Post comment").click
        potentially_wait_for_posting_button
        page.find("button", text: "Post comment")
      end

      def assert_sub_comment_exists(comment)
        find('.evidence-sub-comment-content', text: comment)
      end
  end
end
