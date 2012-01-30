class Topic < OurOhm
  set :channels, Channel
  attribute :title
  index :title

  def self.by_title(title)
    find(title: title).first || new(title: title)
  end
end
