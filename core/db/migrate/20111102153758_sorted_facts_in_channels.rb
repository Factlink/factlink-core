class Channel < OurOhm

  public
  set :contained_channels, Channel

  set :internal_facts, Fact
  set :delete_facts, Fact
  set :cached_facts, Fact

  def self.current_time
   (DateTime.now.to_f*1000).to_i
  end
  sorted_set :sorted_internal_facts, Fact do |f|
   Channel.current_time
  end
  sorted_set :sorted_delete_facts, Fact do |f|
   Channel.current_time
  end
  sorted_set :sorted_cached_facts, Fact do |f|
   Channel.current_time
  end
end

class SortedFactsInChannels < Mongoid::Migration
  def self.up
    say_with_time "move facts in channels from sets to sorted sets" do
      Channel.all.each do |ch|
        ch.internal_facts.each do |f|
          ch.sorted_internal_facts << f
        end
        ch.delete_facts.each do |f|
          ch.sorted_delete_facts << f
        end
        ch.cached_facts.each do |f|
          ch.sorted_cached_facts << f
        end

        ch.internal_facts.clear
        ch.delete_facts.clear
        ch.cached_facts.clear
      end
    end
  end

  def self.down
  end
end