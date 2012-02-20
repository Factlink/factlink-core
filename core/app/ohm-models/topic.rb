class Topic < OurOhm
  attribute :title
  index :title

  def self.by_title(title)
    find(title: title).first || new(title: title)
  end

  def validate
    assert_unique :title
  end
end
