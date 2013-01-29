module Janitor
  class CleanActivityList
    @queue = :janitor

    def initialize(list_key)
      @list = Nest.new(list_key)
    end

    def members_to_remove
      @list.zrange(0,-1).select do |id|
        a = Activity[id]
        a.nil?
      end
    end

    def perform
      # the redis lib does not seem to accept removal of multiple elements
      members_to_remove.each do |member|
        @list.zrem member
      end
    end

    def self.perform(list_key)
      new(list_key).perform()
    end
  end
end