require 'stringex'

class Topic
  include Mongoid::Document
  include Redis::Aid::Ns(:new_topic)

  field :title
  index(title: 1)

  field :slug_title
  index(slug_title: 1)

  validates_uniqueness_of :title
  validates_uniqueness_of :slug_title

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.slug_title = new_title.to_url
  end

  def self.create_by_title(title)
    topic = new(title: title)
    topic.save or raise "Topic.create_by_title failed to save"
    topic
  end
  private_class_method :create_by_title

  def self.by_slug(slug)
    where(slug_title: slug || '').first
  end

  def self.get_or_create_by_channel(ch)
    by_slug(ch.slug_title) || create_by_title(ch.title)
  end

  def top_users(nr=5)
    redis[id][:top_users].zrevrange(0, (nr-1)).map {|id| User.find(id)}.compact
  end

  def top_users_add(user, val)
    redis[id][:top_users].zadd val, user.id
  end

  def channels
    Channel.find(slug_title: self.slug_title)
  end

  def to_param
    slug_title
  end
end
