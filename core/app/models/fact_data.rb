class FactData
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid

  searchable :auto_index => true do
    text    :displaystring
    string  :displaystring
    time    :created_at
  end

  field :title,           :type => String
  field :displaystring,   :type => String   # For matching Fact on a page
  field :passage,         :type => String   # Passage for matching: not implemented
  field :content,         :type => String   # Source content
  field :url,             :type => String 
    # Source url
end