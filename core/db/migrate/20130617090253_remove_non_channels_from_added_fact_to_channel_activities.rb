class RemoveNonChannelsFromAddedFactToChannelActivities < Mongoid::Migration
  def self.up
    Pavlov.command :"activities/clean_up_faulty_add_fact_to_channels"
  end

  def self.down
  end
end
