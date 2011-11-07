module ChannelFunctionality
  
  def related_users(calculator=RelatedUsersCalculator.new,options)
    options[:without] ||= []
    options[:without] << created_by
    calculator.related_users(facts,options)
  end
  
  def to_hash
    return {:id => id, 
            :title => title, 
            :description => description,
            :created_by => created_by,
            :discontinued => discontinued}
  end
  
end

class Channel < OurOhm
  include ActivitySubject
  include ChannelFunctionality
  
  attribute :title
  index :title
  attribute :description

  reference :created_by, GraphUser

  private
  set :contained_channels, Channel

  timestamped_set :sorted_internal_facts, Fact
  timestamped_set :sorted_delete_facts, Fact
  timestamped_set :sorted_cached_facts, Fact

  delegate :unread_count, :mark_as_read, :to => :sorted_cached_facts

  public
  alias :sub_channels :contained_channels

  def prune_invalid_facts
    [sorted_internal_facts, sorted_delete_facts].each do |facts|
      facts.each do |fact|
        if Fact.invalid(fact)
          facts.delete(fact)
        end
      end
    end
  end

  def calculate_facts
    prune_invalid_facts
    fs = sorted_internal_facts
    contained_channels.each do |ch|
      fs |= ch.sorted_cached_facts
    end
    fs -= sorted_delete_facts
    self.sorted_cached_facts = fs
    return self.sorted_cached_facts
  end


  attribute :discontinued
  index :discontinued
  def delete
    self.discontinued = true
    save
  end

  def facts(opts={})
    return [] if new?
    mark_as_read if opts[:mark_as_read]
    sorted_cached_facts.all.delete_if{ |f| Fact.invalid(f) }
  end
  
  def validate
    assert_present :title
    assert_present :created_by
  end

  def add_fact(fact)
    self.sorted_delete_facts.delete(fact)
    self.sorted_internal_facts.add(fact)
    self.sorted_cached_facts.add(fact)
    activity(self.created_by,:added,fact,:to,self)
  end

  def remove_fact(fact)
    self.sorted_internal_facts.delete(fact) if self.sorted_internal_facts.include?(fact)
    self.sorted_cached_facts.delete(fact)   if self.sorted_cached_facts.include?(fact)
    self.sorted_delete_facts.add(fact)
    activity(self.created_by,:removed,fact,:from,self)
  end

  def to_s
    self.id
  end
  
  
  def include?(obj)
    self.sorted_cached_facts.include?(obj)
  end
  
  def editable?
    true
  end
  
  def followable?
    true
  end

  def fork(user)
    c = Channel.create(:created_by => user, :title => title, :description => description)
    c._add_channel(self)
    activity(user,:forked,self,:to,c)
    c
  end


  def add_channel(channel)
    _add_channel(channel)
    activity(self.created_by,:added,channel,:to,self)
  end

  protected
  def _add_channel(channel)
    contained_channels << channel
    calculate_facts
  end

  def self.recalculate_all
    if all
      all.each do |ch|
        ch.calculate_facts
      end
    end
  end



end