class AddSlugTitleToAllChannels < Mongoid::Migration
  def self.up
    say_with_time "ensuring slug_title for all channels" do
      GraphUser.all.each do |gu|
        channels = Channel.all.find(created_by_id: gu.id)
        channels.each do |ch|
          if ch.title.nil?
            if ch.type == 'stream'
              ch.title = 'All'
            elsif ch.type == 'created'
              ch.title = 'Created'
            end
          end
          puts ch.id
          ch.title = ch.title # also trigger the functionality which is called after setting the title
          ch.save
        end
      end
    end
  end

  def self.down
  end
end