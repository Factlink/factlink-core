class RemoveOpinions < Mongoid::Migration
  def self.up
    puts "starting remove_opinions migration"
    while Opinion.all.count > 1000
      Opinion.all.random_member.delete()
    end
    Opinion.all.each {|op| op.delete() }
  end

  def self.down
  end
end