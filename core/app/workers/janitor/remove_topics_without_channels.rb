module Janitor
  class RemoveTopicsWithoutChannels
    @queue = :janitor

    def self.perform()
      Topic.all.each do |t|
        t.delete if (t.channels.count == 0)
      end
    end

  end
end