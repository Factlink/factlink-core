module Acceptance
  module ScrollHelper
    def get_scroll_top
      page.evaluate_script('$("html").scrollTop()')
    end

    def scroll_top_should_eq y
      get_scroll_top.should eq y
    end

    def set_scroll_top_to y
      eventually_succeeds do
        page.execute_script("$('html').scrollTo(#{y});")
        scroll_top_should_eq y
      end
    end
  end
end
