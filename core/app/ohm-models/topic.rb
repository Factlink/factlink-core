require 'stringex'

class Topic < OurOhm
  attribute :title
  index :title

  attribute :slug_title
  index :slug_title

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

  def validate
    execute_callback(:before, :validate) # needed because of ugly ohm contrib callbacks
    super
    assert_unique :title
    assert_unique :slug_title
    execute_callback(:after, :validate) # needed because of ugly ohm contrib callbacks
  end
end
