module Acceptance
  module FactHelper
    include ::FactHelper

    def go_to_discussion_page_of factlink
      path = friendly_fact_path factlink
      visit path
    end

    def backend_create_fact
      backend_create_fact_of_user @user
    end

    def backend_create_fact_of_user user
      create :fact, created_by: user.graph_user
    end

    def wheel_path_d position
      page.evaluate_script("$('.fact-wheel path')[#{position}].getAttribute('d');");
    end

    def wheel_path_opacity position
      page.evaluate_script("$('.fact-wheel path')[#{position}].style.opacity;");
    end

    def click_wheel_part position
      #fire click event on svg element
      page.execute_script("var path = $('.fact-wheel path')[#{position}];var event = document.createEvent('MouseEvents'); event.initMouseEvent('click');path.dispatchEvent(event);")
      wait_for_ajax

      #wait for animation
      sleep 0.3
    end
  end
end
