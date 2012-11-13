module Queries
  class TopicsForChannels
    include Pavlov::Query

    arguments :channels

    def execute
      Topic.any_in(slug_title: slug_titles)
    end

    def slug_titles
      @channels.map {|ch| ch.slug_title}
    end

    def authorized?
      true
    end
  end
end
