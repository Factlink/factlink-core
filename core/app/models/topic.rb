require 'stringex'

class Topic
  include Mongoid::Document
  include Redis::Aid::Ns(:new_topic)

  field :title
  index :title

  field :slug_title
  index :slug_title

  validates_uniqueness_of :title
  validates_uniqueness_of :slug_title

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.slug_title = new_title.to_url
  end

  def channel_for_user(user)
    user.graph_user.internal_channels.find(slug_title: self.slug_title).first
  end

  def self.by_title(title)
    where(slug_title: title.to_url || '').first || new(title: title)
  end

  def self.by_slug(slug)
    where(slug_title: slug || '').first
  end

  def self.ensure_for_channel(ch)
    unless Topic.where(slug_title: ch.slug_title || '').first
      t = Topic.by_title(ch.title)
      t.save and t
    end
  end

  def self.for_channel(ch)
    by_slug(ch.slug_title) or ensure_for_channel(ch)
  end

  def top_channels(nr=5)
    top_users(nr).map { |user| channel_for_user(user) }
  end
  def top_channels_with_fact(nr=5)
    redis[id][:top_channels_with_fact].zrevrange(0, (nr-1)).map {|id| Channel[id] }
  end

  def top_users(nr=5)
    redis[id][:top_users].zrevrange(0, (nr-1)).map {|id| User.find(id)}.delete_if { |u| u.nil? }
  end

  def top_users_add(user, val)
    redis[id][:top_users].zadd val, user.id
    ch = channel_for_user(user)
    redis[id][:top_channels_with_fact].zadd val, ch.id if ch and (ch.added_facts.count > 0)
  end

  def top_users_clear
    redis[id][:top_users].del
    redis[id][:top_channels_with_fact].del
  end

  def channels
    Channel.find(slug_title: self.slug_title)
  end

  include OurOhm::RedisTopFunctionality
  def top_score
    channels.count
  end
  def self.top_key
    Topic.redis[:top]
  end
  def self.top_instance id
    Topic.find(id)
  end
  before_destroy :remove_from_top

end
