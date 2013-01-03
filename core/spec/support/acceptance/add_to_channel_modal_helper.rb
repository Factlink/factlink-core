# coding: utf-8

module Acceptance
  module AddToChannelModalHelper
    def add_to_channel name
      type_into_search_box name
      page.should have_no_content "Add “#{name}” as a new channel"
      page.find('li', text: name).click
      page.find('.auto-complete-results-container', text: "#{name}")
    end

    def add_as_new_channel name
      type_into_search_box name
      page.should have_content "Add “#{name}” as a new channel"
      page.find('li', text: "Add “#{name}” as a new channel").click
      page.find('.auto-complete-results-container', text: "#{name}")
    end

    def type_into_search_box value
      page.find(:css,'input').set(value)
    end

    def added_channels_should_contain name
      page.find(".auto-complete-results-container",text: name)
    end

    def suggested_channels_should_contain name
      page.find(".add-to-channel-suggested-site-topics", text: name)
    end
  end
end
