# coding: utf-8

module Acceptance
  module FactHelper
    include ::FactHelper

    # <IN REPOST MODAL>
    def add_to_channel name
      type_into_search_box name
      page.should_not have_content "Add “#{name}” as a new channel"
      page.find('li', text: name).click
      wait_for_ajax
    end

    def add_as_new_channel name
      type_into_search_box name
      page.should have_content "Add “#{name}” as a new channel"
      page.find('li', text: "Add “#{name}” as a new channel").click
      wait_for_ajax
    end

    def type_into_search_box value
      page.find(:css,'input').set(value)
    end

    def added_channels_should_contain name
      within(:css, ".auto-complete-results-container") do
        page.should have_content name
      end
    end
    # </IN REPOST MODAL>

    def go_to_discussion_page_of factlink
      path = friendly_fact_path factlink
      visit path
    end

    def backend_create_fact
      backend_create_fact_of_user @user
    end

    def backend_create_fact_of_user user
      create :fact, created_by: user.graph_user
    end
  end
end
