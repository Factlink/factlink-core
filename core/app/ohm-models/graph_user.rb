class GraphUser < OurOhm
  # small helper so we can write functions which
  # accept both users and graph_users
  # mostly legacy, but hard to debug whether we still need
  # this, so leaving for now.
  def graph_user
    self
  end

  # data
  reference :user, ->(id) { id && User.find(id) }

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

  def opinion_on(fact)
    UserOpinion.new(self).on(fact)
  end
end
