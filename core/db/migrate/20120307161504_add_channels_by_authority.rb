class AddChannelsByAuthority < Mongoid::Migration
  def self.up
    Channel.all.each do |ch|
      ch.add_to_graph_user
    end
  end

  def self.down
  end
end