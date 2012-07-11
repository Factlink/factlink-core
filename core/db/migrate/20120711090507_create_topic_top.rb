class CreateTopicTop < Mongoid::Migration
  def self.up
    Topic.all.each do |t|
      t.reposition_in_top
    end
  end

  def self.down
  end
end