module Acceptance
  module FactHelper
    include ::FactHelper

    def go_to_discussion_page_of factlink
      visit '/client/blank'
      find('.spec-discussion-sidebar-container')
      page.execute_script "clientEnvoy.showFactlink(#{factlink.id})"
      find('.spec-button-believes')
    end

    def backend_create_fact
      create :fact
    end

    def backend_create_fact_with_long_text
      fact_data = create :fact_data, displaystring: 'long'*30
      create :fact, data: fact_data
    end

    def click_agree fact, user
      find('.spec-button-believes').click


      eventually_succeeds do
        expect(fact.believable.opinion_of_graph_user(user.graph_user)).to eq "believes"
      end
    end
  end
end
