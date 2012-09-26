class FactData
  include Mongoid::Document
  include Mongoid::Timestamps

  include Sunspot::Mongoid
  attr_accessible []

  searchable auto_index: true do
    text    :displaystring, stored: true
    string  :fact_id
    text    :title
    time    :created_at
  end

  field :title,           type: String
  field :displaystring,   type: String
  field :fact_id,         type: String

  validates_format_of :displaystring, allow_nil: true, with: /\S/

  def self.column_names
    self.fields.collect { |field| field[0] }
  end

  def to_s
    self.displaystring || ""
  end

  def fact
    @fact ||= Fact[fact_id]
  end

  #returns whether a given factdata should be considered
  #unsuitable for usage/viewing
  def self.invalid(fd)
    not valid(fd)
  end

  def self.valid(fd)
    fd and fd.fact_id and fd.fact
  end

end
