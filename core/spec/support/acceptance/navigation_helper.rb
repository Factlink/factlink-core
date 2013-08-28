module Acceptance
  module NavigationHelper
    def open_modal tab_title, &block
      click_link(tab_title)
      within_modal(&block)
    end

    def within_modal &block
      within(:css, "#modal_region .modal-window-body") do
        yield
      end
    end

    def close_modal
      find("#modal_region .js-layer").click
    end
  end
end
