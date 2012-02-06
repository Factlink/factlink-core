
class Channel < OurOhm
  reference :created_by, GraphUser
  index :created_by_id
  def validate
  end
end

class AddIndexForChannelCreatedBy < Mongoid::Migration
  def self.up
    say_with_time "add created_by_index to Channels" do
      Channel.all.each do |ch|
        ch.save
      end
    end
  end

  def self.down
  end
end
