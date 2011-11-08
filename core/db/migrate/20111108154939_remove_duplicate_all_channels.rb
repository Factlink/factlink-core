class RemoveDuplicateAllChannels < Mongoid::Migration
  def self.up
    GraphUser.all.each do |gu|
      userstreams = Channel.find(:created_by_id=>gu.id).all.find_all {|x| x.class == Channel::UserStream }
      userstreams[1,99999].each do |ch|
        ch.destroy
      end
      gu.stream = userstream.first
      gu.save 
    end
  end

  def self.down
  end
end