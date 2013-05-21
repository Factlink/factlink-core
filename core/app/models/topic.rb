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

  def top_users(nr=5)
    redis[id][:top_users].zrevrange(0, (nr-1)).map {|id| User.find(id)}.compact
  end

  def top_users_add(user, val)
    redis[id][:top_users].zadd val, user.id
  end

  def top_users_clear
    redis[id][:top_users].del
  end

  def channels
    Channel.find(slug_title: self.slug_title)
  end

  def to_param
    slug_title
  end
end
