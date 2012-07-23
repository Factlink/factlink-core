class PrefillAddedFacts < Mongoid::Migration
  def self.up
    Activity.all.find(action: 'added_fact_to_channel').ids.each do |id|
      Resque.enqueue(ProcessActivity, id)
    end
  end

  def self.down
  end
end