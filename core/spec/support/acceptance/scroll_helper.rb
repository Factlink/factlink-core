module Acceptance
  module ScrollHelper
    def get_scroll_top
      page.evaluate_script('$("body").scrollTop();')
    end

    def set_scroll_top_to y
      page.execute_script("$('body').scrollTo(#{y});")
    end
  end
end
