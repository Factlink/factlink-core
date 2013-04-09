class MigrateSubchannelsWithDifferentTitle < Mongoid::Migration
  def self.up
    say_with_time "Creating jobs to migrate away subchannels with a different title" do
      Channel.all.ids.each do |channel_id|
        Resque.enqueue MoveAwaySubchannelsWithOtherTitle, channel_id
      end
    end
  end

  def self.down
  end
end
