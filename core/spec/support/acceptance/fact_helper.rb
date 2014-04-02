module Acceptance
  module FactHelper
    def open_discussion_sidebar_for factlink
      visit '/client/blank'
      find('.spec-discussion-sidebar-region')
      page.execute_script "clientEnvoy.showFactlink(#{factlink.id})"
      find('.spec-button-interesting')
    end

    def backend_create_fact_with_long_text
      fact_data = create :fact_data, displaystring: 'long'*30
      create :fact, data: fact_data
    end
  end
end
