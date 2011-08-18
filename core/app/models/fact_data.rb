class FactData
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid

  searchable :auto_index => true do

    # autocomplete  :fact_data_displaystring, :using => :displaystring
    # autosuggest   :fact_data_displaystring, :using => :displaystring
    
    text    :displaystring
    string  :displaystring
    time    :created_at
  end

  field :title,           :type => String
  field :displaystring,   :type => String   # For matching Fact on a page
  field :passage,         :type => String   # Passage for matching: not implemented
  field :content,         :type => String   # Source content
  field :fact_id,         :type => String

  def self.column_names
    self.fields.collect { |field| field[0] }
  end

  def to_s
    self.displaystring || ""
  end

  def fact
    Fact[fact_id]
  end
  
end