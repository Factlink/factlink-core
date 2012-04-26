require 'stringex'

class Topic < OurOhm
  attribute :title
  index :title

  attribute :slug_title
  index :slug_title

  sorted_set :top_users, GraphUser

  alias :old_set_title :title= unless method_defined?(:old_set_title)
  def title=(new_title)
    old_set_title new_title
    self.slug_title = new_title.to_url
  end

  def self.by_title(title)
    find(slug_title: title.to_url).first || new(title: title)
  end

  def self.by_slug(slug)
    find(slug_title: slug).first
  end

  def self.ensure_for_channel(ch)
    unless Topic.find(slug_title: ch.slug_title||'').first
      t = Topic.by_title(ch.title)
      t.save and t
    end
  end

  def self.for_channel(ch)
    by_slug(ch.slug_title) or ensure_for_channel(ch)
  end

  def validate
    execute_callback(:before, :validate) # needed because of ugly ohm contrib callbacks
    super
    assert_unique :title
    assert_unique :slug_title
    execute_callback(:after, :validate) # needed because of ugly ohm contrib callbacks
  end
end
