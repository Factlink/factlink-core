module Acceptance
  module ScrollHelper
    def get_scroll_top
      page.evaluate_script('$("body").scrollTop();')
    end

    def scroll_top_should_eq y
      wait_until {get_scroll_top == y}
    end

    def set_scroll_top_to y
      page.execute_script("$('body').scrollTo(#{y});")
      scroll_top_should_eq y
    end
  end
end
