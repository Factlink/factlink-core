# coding: utf-8

module Acceptance
  module AddToChannelModalHelper
    def add_to_channel name
      type_into_search_box name
      page.should have_no_content "Add “#{name}” as a new channel"
      page.find('li', text: name).click
      sleep 3
      page.find('.auto-complete-results-container').find("li", text: "#{name}")
    end

    def add_as_new_channel name
      type_into_search_box name
      page.should have_content "Add “#{name}” as a new channel"
      item = page.find('li', text: "Add “#{name}” as a new channel")
      sleep 3
      item.click
      page.find('.auto-complete-results-container').find("li", text: "#{name}")
    end

    def type_into_search_box value
      page.find(:css,'input').set(value)
    end

    def added_channels_should_contain name
      within(:css, ".auto-complete-results-container") do
        page.should have_content name
      end
    end

    def suggested_channels_should_contain name
      within(:css, ".add-to-channel-suggested-site-topics") do
        page.find("li", text: name)
      end
    end
  end
end
