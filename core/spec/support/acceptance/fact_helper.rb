module Acceptance
  module FactHelper
    include ::FactHelper

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

    def add_evidence evidence_factlink
      text = evidence_factlink.to_s
      page.find("input").set(text)
      page.find("li", text: text).click
      page.find("input", visible: false)
      page.find_button("Post Factlink").click
    end
  end
end
