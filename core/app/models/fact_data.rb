class FactData
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid

  searchable :auto_index => true do
    text    :displaystring, :stored => true
    string  :fact_id
    text    :title
    time    :created_at
  end

  field :title,           :type => String
  field :displaystring,   :type => String
  field :passage,         :type => String
  field :content,         :type => String
  field :fact_id,         :type => String

  def self.column_names
    self.fields.collect { |field| field[0] }
  end

  def to_s
    self.displaystring || ""
  end

  def fact
    @fact ||= Fact[fact_id]
  end

end