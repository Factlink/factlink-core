class RecalculateChannelStructure < Mongoid::Migration
  def self.up
    inlijn = Resque.inline
    Resque.inline = true

    Channel.all.each do |ch|
      ch.sorted_cached_facts.key.del
    end

    Channel.all.each do |ch|
      ch.sorted_internal_facts.below('inf', withscores:true).each do |fact|
        Resque.enqueue(AddFactToChannelJob, fact[:item].id, ch.id, fact[:score])
      end
    end

    Channel.all.each do |ch|
      ch.sorted_delete_facts.each do |fact|
        Resque.enqueue(RemoveFactFromChannel, fact.id, ch.id)
      end
    end

    Resque.inline = inlijn
  end

  def self.down
  end
end
