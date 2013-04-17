module Acceptance
  module TopicHelper

    def go_to_topic_page_of topic
      visit topic_path(topic)
    end

    def click_topic_in_sidebar topic_title
      find('#left-column a', text: topic_title).click
    end

    def assert_on_topic_page topic
      expect(current_path).to eq topic_path(topic)
    end

    def switch_to_factlinks_from_people_i_follow
      page.select 'Factlinks from people I follow', from: 'channel-topic-switch'
    end

  end
end
