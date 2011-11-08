class RenameUserstreams < Mongoid::Migration
  def self.up
    Channel.all.key.smembers.map {|x| Channel.key[x] }.each do |ch_key|
      if ch_key.hget('_type') == "UserStream"
        puts "Renaming #{ch_key}"
        ch_key.hset('_type', "Channel::UserStream")
      end
    end
  end

  def self.down
  end
end