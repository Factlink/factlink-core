module Acceptance
  module FactHelper
    include ::FactHelper

    def go_to_discussion_page_of factlink
      visit friendly_fact_path factlink
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
      if Capybara.current_driver == :poltergeist then
        #workaround for https://github.com/jonleighton/poltergeist/issues/331
        page.execute_script("
          var svgEl = document.querySelectorAll('#{css_path} .fact-wheel path')[#{position}];
          var clickEvent = document.createEvent('MouseEvents');
          clickEvent.initMouseEvent('click',true,true);
          svgEl.dispatchEvent(clickEvent);
        ")
      else
        svg_path_el = find("#{css_path} .fact-wheel path:nth-of-type(#{position+1})")
        svg_path_el.click
      end
    end
  end
end
