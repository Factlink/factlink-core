class RecalculateActivity < Mongoid::Migration
  def self.up
    Activity.all.each do |a|
      a.process_activity
    end
  end

  def self.down
  end
end