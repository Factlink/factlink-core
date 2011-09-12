class RemoveOpinions < Mongoid::Migration
  def self.up
    Opinion.all.each do |op|
      op.delete()
    end
  end

  def self.down
  end
end