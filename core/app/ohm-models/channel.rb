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

  def calculate_facts
    fs = internal_facts
    contained_channels.each do |ch|
      fs |= ch.facts
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

  alias :facts :cached_facts

  def validate
    assert_present :title
    assert_present :created_by
  end

  def add_fact(fact)
    self.delete_facts.delete(fact)
    self.internal_facts.add(fact)
    activity(self.created_by,:added,fact,:to,self)
  end

  def remove_fact(fact)
    if self.internal_facts.include?(fact)
      self.internal_facts.delete(fact)
    end
    self.delete_facts.add(fact)
    activity(self.created_by,:removed,fact,:from,self)
  end

  def to_s
    self.id
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
  def initialize(graph_user)
    @graph_user = graph_user
  end
  
  def facts
    facts = (@graph_user.created_facts & Fact.all)
    facts = @graph_user.channels.map{|ch| ch.facts}.reduce(facts,:|)
    facts.all
  end
end