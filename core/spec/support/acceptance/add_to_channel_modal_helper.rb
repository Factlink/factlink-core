# coding: utf-8

module Acceptance
  module AddToChannelModalHelper
    def add_to_channel name
      type_into_search_box name
      page.should have_no_content "Add “#{name}” as a new channel"
      slow_click('li', text: name)
      page.find('.auto-complete-results-container').should have_content(name)
    end

    def add_as_new_channel name
      type_into_search_box name
      page.should have_content "Create a new channel called “#{name}”"
      slow_click('li', text: "Create a new channel called “#{name}”")
      page.find('.auto-complete-results-container').should have_content(name)
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

    def slow_click *args
      # first we wait for the element to appear
      find(*args)
      # now we wait for it to be moved around a little because
      # of redrawing and stuff
      sleep 1
      # once the element doesn't move anymore we click
      find(*args).click
    end
  end
end
