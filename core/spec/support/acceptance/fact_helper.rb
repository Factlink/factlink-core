module Acceptance
  module FactHelper
    include ::FactHelper

    def create_factlink(user)
      create(:fact, created_by: user.graph_user)
    end

    def go_to_discussion_page_of factlink
      path = friendly_fact_path factlink
      visit path
    end

    def go_to_fact_show_of factlink
      visit fact_path factlink
    end

    def backend_create_fact
      backend_create_fact_of_user @user
    end

    def backend_create_fact_of_user user
      create :fact, created_by: user.graph_user
    end

    def wheel_path_d position
      page.evaluate_script("$('.fact-wheel path')[#{position}].getAttribute('d');")
    end

    def wheel_path_opacity position
      page.evaluate_script("$('.fact-wheel path')[#{position}].style.opacity;")
    end

    def click_wheel_part position, css_path=''
      #fire click event on svg element
      svg_path_el = all("#{css_path} .fact-wheel path")[position]
      svg_path_el.click
      # page.execute_script("
      #   var path = $('#{css_path} .fact-wheel path')[#{position}];
      #   $(path).trigger('click');
      #   ")
      # wait_for_ajax

      #wait for animation
      # sleep 3.3
    end
  end
end
