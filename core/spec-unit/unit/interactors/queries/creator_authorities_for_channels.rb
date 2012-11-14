module Queries
  class CreatorAuthoritiesForChannels
    include Pavlov::Query
    arguments :channel_ids
    def authorized?
      true
    end
  end
end
