class GraphUser < OurOhm
  # helper
  def graph_user;return self;end

  # data
  reference :user, lambda { |id| id && User.find(id) }

  timestamped_set :notifications, Activity
  timestamped_set :stream_activities, Activity

  collection :created_facts, Basefact, :created_by

  reference :stream, Channel::UserStream
  reference :created_facts_channel, Channel::CreatedFacts

  # creation logic
  def create_stream
    self.stream = Channel::UserStream.create(:created_by => self)
    save
  end
  after :create, :create_stream

  def create_created_facts_channel
    self.created_facts_channel = Channel::CreatedFacts.create(:created_by => self)
    save
  end
  after :create, :create_created_facts_channel

  # opinion logic
  def has_opinion?(type, fact)
    fact.opiniated(type).include? self
  end
  private :has_opinion?

  def opinion_on(fact)
    Opinion.types.each do |opinion|
      return opinion if has_opinion?(opinion,fact)
    end
    return nil
  end

end
