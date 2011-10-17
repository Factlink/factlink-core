class Channel < OurOhm
  include ActivitySubject

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
  
  # Ohm Model needs to have a definition of which fields to render
  def to_hash
    super.merge(:_id => id, 
                :title => title, 
                :description => description,
                :created_by => created_by,
                :facts => facts,
                :discontinued => discontinued)
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
  attr_accessor :id, :graph_user, :facts, :title, :description, :related_users
  
  def initialize(graph_user)
    @graph_user = graph_user
    @facts = self.get_facts
    @title = "All"
    @id = "all"
    @description = "All facts"
    @created_by = @graph_user
    @related_users = []
  end
  
  def get_facts
    facts = (Fact.all & @graph_user.created_facts)
    facts = @graph_user.internal_channels.map{|ch| ch.cached_facts}.reduce(facts,:|)
    
    facts.all.delete_if{ |f| Fact.invalid(f) }.reverse
  end
  
  public
  def editable?
    false
  end
  
  def followable?
    false
  end
end