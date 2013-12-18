module Acceptance
  module FactHelper
    include ::FactHelper

    def go_to_discussion_page_of factlink
      visit friendly_fact_path factlink
    end

    def go_to_fact_show_of factlink
      visit client_fact_path factlink
    end

    def backend_create_fact
      backend_create_fact_of_user @user
    end

    def backend_create_fact_with_long_text
      fact_data = create :fact_data, displaystring: 'long'*30
      create :fact, created_by: @user.graph_user, data: fact_data
    end

    def backend_create_fact_of_user user
      create :fact, created_by: user.graph_user
    end

    def click_agree
      # TODO: use `click_button 'Agree'` when getting rid of the "agree/disagree/add comment" box
      first('button', text: 'Agree').click
    end
  end
end
