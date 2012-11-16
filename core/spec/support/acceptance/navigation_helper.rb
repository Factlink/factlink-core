module Acceptance
  module NavigationHelper
    include ::FactHelper # not Acceptance::FactHelper

    def go_to_discussion_page_of factlink
      path = friendly_fact_path factlink
      visit path
    end

    def go_to_channel_page_of channel
      path = channel_path @user, channel
      visit path
    end

    def open_modal tab_title, &block
      tablink = page.find_link(tab_title)

      tab_class = tablink['class'].split(/\s+/).first + '-container'

      click_link(tab_title)
      within(:css, ".#{tab_class} .modal-body") do
        yield
      end
    end

    def type_into_search_box value
      page.find(:css,'input').set(value)
    end

    def go_to_first_fact
      find('a.discussion_link').click
    end

    def go_back_using_button
      find('.titleRegion a.btn-back').click
    end
  end
end
