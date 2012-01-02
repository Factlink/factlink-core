class RenameUserstreams < Mongoid::Migration
  def self.up
    say_with_time "renameing userstream to channel::userstream (needed because the class moved)" do
      Channel.all.key.smembers.map {|x| Channel.key[x] }.each do |ch_key|
        if ch_key.hget('_type') == "UserStream"
          puts "Renaming #{ch_key}"
          ch_key.hset('_type', "Channel::UserStream")
        end
      end
    end
  end

  def self.down
  end
end