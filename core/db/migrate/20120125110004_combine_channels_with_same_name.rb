class CombineChannelsWithSameName < Mongoid::Migration
  def self.up
    say_with_time "add created_by_index to Channels" do
      GraphUser.all.each do |gu|
        fixed = {}
        real_channels = Channel.all.find(created_by_id: gu.id).find_all { |ch| ch.class == Channel }
        real_channels.each do |ch|
          if fixed[ch.title]
            fixed[ch.title].singleton_class.send :include, Channel::Overtaker
            puts "Combining #{fixed[ch.title]} and #{ch.id}"
            fixed[ch.title].take_over(ch)
            puts "Deleting #{ch.id}"
            ch.delete
          else
            fixed[ch.title] = ch
          end
        end
      end
    end
  end

  def self.down
  end
end
