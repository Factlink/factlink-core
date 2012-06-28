class ResetTopicTopUsers < Mongoid::Migration
  def self.up
    Topic.all.each do |t|
      puts "yo #{t}"
      t.top_users_clear
    end
  end

  def self.down
  end
end