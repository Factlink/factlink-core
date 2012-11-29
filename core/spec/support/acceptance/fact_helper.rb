# coding: utf-8

module Acceptance
  module FactHelper
    include ::FactHelper

    # <IN REPOST MODAL>
    def add_to_channel name
      using_wait_time(15) do
        type_into_search_box name
        page.should_not have_content "Add “#{name}” as a new channel"
        page.find('li', text: name).click
        page.find('.auto-complete-results-container').should have_content("#{name}")
      end
    end

    def add_as_new_channel name
      using_wait_time(15) do
        type_into_search_box name
        page.should have_content "Add “#{name}” as a new channel"
        page.find('li', text: "Add “#{name}” as a new channel").click
        page.find('.auto-complete-results-container').should have_content("#{name}")
      end
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
      fact = create :fact, created_by: user.graph_user
      sleep 5 # let ElasticSearch index it
      fact
    end

    def add_evidence evidence_factlink
      text = evidence_factlink.to_s
      page.find("input").set(text)
      page.find("li", text: text).click
      page.find("input", visible: false)
      page.find_button("Post Factlink").click
    end
  end
end
