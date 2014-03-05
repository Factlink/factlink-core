class AddGlobalActivities < Mongoid::Migration
  def self.up
    Activity.all.ids.each do |id|
      Resque.enqueue(ProcessActivity, id)
    end
  end

  def self.down
  end
end
