module Janitor
  class CleanActivityList
    @queue = :janitor

    def initialize(list_key)
      @list = Nest.new(list_key)
    end

    def members_to_remove
      @list.zrange(0,-1).keep_if do |id|
        a = Activity[id]
        a.nil?
      end
    end

    def perform
      @list.zrem *members_to_remove
    end

    def self.perform(list_key)
      new(list_key).perform()
    end
  end
end