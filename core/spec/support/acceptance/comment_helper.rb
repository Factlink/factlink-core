module Acceptance
  module CommentHelper
      def toggle_to_comment
        within add_evidence_form_css_selector do
          evidence_input = page.find_field 'text_input_view'
          evidence_input.click

          page.find('.js-switch').set true
        end
      end

      def toggle_to_factlink
        within add_evidence_form_css_selector do
          page.find('.js-switch').set false
        end
      end

      def posting_factlink?
        find('.fact-relation-search input[type=text]')[:placeholder]
          .include? 'Factlink'
      end

      def posting_comment?
        find('.fact-relation-search input[type=text]')[:placeholder]
          .include? 'Comment'
      end

      def add_comment comment
        toggle_to_comment if posting_factlink? #unless posting_comment?

        within add_evidence_form_css_selector do
          Timeout.timeout(Capybara.default_wait_time) do
            # wait for all ajax requests to complete
            # if we don't wait, the server may see it after the db is cleaned
            # and a request for a removed object will cause a crash (nil ref).
            sleep(0.1) until page.evaluate_script('jQuery.active') == 0
          end
          comment_input = page.find_field 'add_comment'

          comment_input.click
          comment_input.set comment
          comment_input.value.should eq comment
          click_button 'Post comment'
        end
      end

      def add_existing_factlink evidence_factlink
        toggle_to_factlink unless posting_factlink?

        within add_evidence_form_css_selector do
          text = evidence_factlink.to_s
          page.find("input[type=text]").click
          page.find("input[type=text]").set(text)
          page.find("li", text: text).click
          page.find_button("Post Factlink").click
        end
      end

      def add_new_factlink text
        toggle_to_factlink unless posting_factlink?

        within add_evidence_form_css_selector do
          page.find("input[type=text]").set(text)
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
