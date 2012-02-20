class SaveChannels < Mongoid::Migration
  def self.up
    Channel.all.each do |ch|
      ch.save
    end
  end

  def self.down
  end
end