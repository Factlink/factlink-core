# coding: utf-8

# TODO: the idea is to make a number of helpers for acceptance tests,
# but this helper was made originally for add_fact_to_channel_spec.
# Refactor this into different helpers, and without using instance variables.

module Acceptance
  module ChannelHelper
    include FactHelper
    def add_as_new_channel name
        type_into_search_box name
        page.should have_content "Add “#{name}” as a new channel"
        page.find('li', text: "Add “#{name}” as a new channel").click
        wait_for_ajax
    end

    def add_to_channel name
        type_into_search_box name
        page.should_not have_content "Add “#{name}” as a new channel"
        page.find('li', text: name).click
        wait_for_ajax
    end

    def go_to_discussion_page_of factlink
      path = friendly_fact_path factlink
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

    def create_fact_in_backend
      create :fact, created_by: @user.graph_user
    end

    def create_channel_in_backend
      create :channel, created_by: @user.graph_user
    end

    def type_into_search_box value
      page.find(:css,'input').set(value)
    end

    def added_channels_should_contain name
      within(:css, ".auto-complete-results-container") do
        page.should have_content name
      end
    end
  end
end
