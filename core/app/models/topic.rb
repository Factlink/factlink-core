class Topic
  include Mongoid::Document

  def self.redis
    Nest.new(:new_topic)
  end

  field :title
  index(title: 1)

  field :slug_title
  index(slug_title: 1)

  validates_uniqueness_of :title
  validates_uniqueness_of :slug_title

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.slug_title = new_title.gsub(/\W/,'-').downcase
  end

  def self.create_by_title(title)
    topic = new(title: title)
    topic.save or fail "Topic.create_by_title failed to save"
    topic
  end
  private_class_method :create_by_title

  def self.by_slug(slug)
    where(slug_title: slug || '').first
  end

  def self.get_or_create_by_channel(ch)
    by_slug(ch.slug_title) || create_by_title(ch.title)
  end

  def to_param
    slug_title
  end
end
