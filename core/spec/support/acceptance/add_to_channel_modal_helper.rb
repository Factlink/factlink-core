# coding: utf-8

module Acceptance
  module AddToChannelModalHelper
    def open_repost_modal &block
       # cannot use open_modal because that assumes we click a link, not a button
      click_button 'Repost to topic'
      within_modal &block
    end

    def add_to_channel name
      type_into_search_box name
      page.should have_no_content "Add “#{name}” as a new topic"
      slow_click('li', text: name)
      page.find('.auto-complete-results-container').should have_content(name)
    end

    def add_as_new_channel name
      type_into_search_box name
      page.should have_content "Create a new topic called “#{name}”"
      slow_click('li', text: "Create a new topic called “#{name}”")
      page.find('.auto-complete-results-container').should have_content(name)
    end

    def type_into_search_box value
      input = page.find(:css,'input[type=text]')
      input.click
      input.set(value)
    end

    def added_channels_should_contain name
      page.find(".auto-complete-results-container",text: name)
    end

    def suggested_channels_should_contain name
      page.find(".add-to-channel-suggested-topics", text: name)
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
