class NewTopFacts < Mongoid::Migration
  def self.up
    say_with_time "recalculating top users" do
      GraphUser.all.each do |gu|
        gu.reposition_in_top_users
      end
    end
  end

  def self.down
  end
end
