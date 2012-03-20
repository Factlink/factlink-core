class ConvertToSluggedChannels < Mongoid::Migration
  def self.up
    say_with_time "removing all topics (will be recreated by channels)" do
      Topic.all.each do |t|
        t.delete
      end
    end
    say_with_time "combining channels with the same slug" do
      GraphUser.all.each do |gu|
        fixed = {}
        real_channels = Channel.all.find(created_by_id: gu.id).find_all { |ch| ch.class == Channel }
        real_channels.each do |ch|
          if fixed[ch.slug_title]
            fixed[ch.slug_title].singleton_class.send :include, Channel::Overtaker
            puts "Combining #{fixed[ch.slug_title]} and #{ch.id}"
            fixed[ch.slug_title].take_over(ch)
            puts "Deleting #{ch.id}"
            ch.real_delete
          else
            fixed[ch.slug_title] = ch
          end
          ch.save
        end
      end
    end    
  end

  def self.down
  end
end