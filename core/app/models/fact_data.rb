class FactData
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible []

  field :title,           type: String
  field :displaystring,   type: String
  field :fact_id,         type: String

  has_many :conversations, as: :subject

  validates_format_of :displaystring, allow_nil: true, with: /\S/

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
