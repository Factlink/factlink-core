module Acceptance
  module NavigationHelper
    def open_modal tab_title, &block
      click_link(tab_title)

      within(:css, "#modal_region .modal-body") do
        yield
      end
    end

    def go_back_using_button
      find('.titleRegion a.btn-back').click
    end
  end
end
