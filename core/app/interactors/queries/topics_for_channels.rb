module Queries
  class TopicsForChannels
    include Pavlov::Query

    arguments :channels, :pavlov_options

    def execute
      Topic.any_in(slug_title: slug_titles).to_a
    end

    def slug_titles
      @channels.map(&:slug_title)
    end
  end
end
