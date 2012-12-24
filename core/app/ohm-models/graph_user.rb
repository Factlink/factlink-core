class GraphUser < OurOhm
  include Activity::Subject

  def graph_user
    return self
  end

  reference :user, lambda { |id| id && User.find(id) }

  timestamped_set :notifications, Activity
  timestamped_set :stream_activities, Activity

  collection :created_facts, Basefact, :created_by

  # TODO
  # check if memoization is really needed, if so, memoize locally
  # then remove memoization
  # then move to channellist
  define_memoized_method :channels do
    channels = ChannelList.new(self).sorted_real_channels_as_array

    channels.unshift(self.created_facts_channel)
    channels.unshift(self.stream )

    channels
  end
  # / TODO

  reference :stream, Channel::UserStream
  def create_stream
    self.stream = Channel::UserStream.create(:created_by => self)
    save
  end
  after :create, :create_stream

  reference :created_facts_channel, Channel::CreatedFacts
  def create_created_facts_channel
    self.created_facts_channel = Channel::CreatedFacts.create(:created_by => self)
    save
  end
  after :create, :create_created_facts_channel


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
