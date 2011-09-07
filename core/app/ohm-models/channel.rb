class Channel < OurOhm
  include ActivitySubject

  attribute :title
  index :title
  attribute :description

  reference :created_by, GraphUser

  attribute :backend_is_fork
  
  def is_fork=(value)
    self.backend_is_fork = value.to_s
  end
  def is_fork(*params)
    self.backend_is_fork== 'true'
  end
  
  alias :channel_maintainer :created_by

  private
  set :contained_channels, Channel
  set :internal_facts, Fact
  set :delete_facts, Fact
  set :cached_facts, Fact



  public
  alias :sub_channels :contained_channels

  def calculate_facts
    # TODO very dirty, refactor ohm so this works with the commented-out line, and efficiently does the def the | and the -
    fs = internal_facts
    contained_channels.each do |ch|
      fs |= ch.facts
    end
    fs -= delete_facts

    #self.cached_facts = fs
    # a 'bit' less efficient:
    cached_facts.clear
    fs.each do |f|
      if f != nil
        cached_facts << f
      end
    end
    save
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
    c = Channel.create(:created_by => user, :title => title, :description => description, :is_fork => true)
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

  #if one of the following methods is executed and the channel was a fork, it isn't anymore
  [:add_channel, :remove_fact, :add_fact, :title=, :description=].each do |m|
    orig = instance_method m
    send :define_method, m do |*args|
      self.is_fork = false
      orig.bind(self).call *args
    end
  end

end