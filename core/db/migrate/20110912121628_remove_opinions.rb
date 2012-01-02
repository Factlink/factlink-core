class RemoveOpinions < Mongoid::Migration
  def self.up
    say_with_time "starting remove_opinions migration" do
      while Opinion.all.count > 1000
        Opinion.all.random_member.delete()
      end
      Opinion.all.each {|op| op.delete() }
    end
  end

  def self.down
  end
end