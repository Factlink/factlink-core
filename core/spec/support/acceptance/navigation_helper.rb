module Acceptance
  module NavigationHelper
    def open_modal tab_title, &block
      tablink = page.find_link(tab_title)

      tab_class = tablink['class'].split(/\s+/).first + '-container'

      click_link(tab_title)
      within(:css, ".#{tab_class} .modal-body") do
        yield
      end
    end

    def go_back_using_button
      find('.titleRegion a.btn-back').click
    end
  end
end
