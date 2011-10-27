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
  set :internal_facts, Fact
  set :delete_facts, Fact
  set :cached_facts, Fact

  public
  alias :sub_channels :contained_channels

  def prune_invalid_facts
    [internal_facts, delete_facts].each do |facts|
      facts.key.smembers.each do |id|
        fact = Fact[id]
        if Fact.invalid(fact)
          facts.key.srem(id)
        end
      end
    end
  end

  def calculate_facts
    prune_invalid_facts
    fs = internal_facts
    contained_channels.each do |ch|
      fs |= ch.cached_facts
    end
    fs -= delete_facts
    self.cached_facts = fs
  end


  attribute :discontinued
  index :discontinued
  def delete
    self.discontinued = true
    save
  end

  def facts
    return [] if new?
    
    cached_facts.all.delete_if{ |f| Fact.invalid(f) }
  end
  
  def validate
    assert_present :title
    assert_present :created_by
  end

  def add_fact(fact)
    self.delete_facts.delete(fact)
    self.internal_facts.add(fact)
    self.cached_facts.add(fact)
    activity(self.created_by,:added,fact,:to,self)
  end

  def remove_fact(fact)
    self.internal_facts.delete(fact) if self.internal_facts.include?(fact)
    self.cached_facts.delete(fact)   if self.cached_facts.include?(fact)
    self.delete_facts.add(fact)
    activity(self.created_by,:removed,fact,:from,self)
  end

  def to_s
    self.id
  end
  
  
  def include?(obj)
    self.cached_facts.include?(obj)
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

class UserStream
  include ChannelFunctionality
  
  attr_accessor :id, :created_by, :title, :description, :facts
  
  def initialize(graph_user)
    @title = "All"
    @id = "all"
    @description = "All facts"
    @created_by = graph_user
    @facts = self.get_facts #TODO define good as_json, but a bit to much work to do neatly before demo 18/10
  end
  
  def get_facts
    int_facts = (Fact.all & @created_by.created_facts)
    int_facts = @created_by.internal_channels.map{|ch| ch.cached_facts}.reduce(int_facts,:|)
    int_facts.all.delete_if{ |f| Fact.invalid(f) }.reverse
  end

  
  alias :graph_user :created_by

  def include?(obj)
    facts.include?(obj)
  end

  def discontinued
    false
  end
  
  def editable?
    false
  end
  
  def followable?
    false
  end

end