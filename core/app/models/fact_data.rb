class FactData
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible []

  field :title,           type: String
  field :displaystring,   type: String
  field :fact_id,         type: String

  has_many :conversations

  validates_format_of :displaystring, allow_nil: true, with: /\S/

  def to_s
    displaystring || ""
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

  after_create do |fact_data|
    Pavlov.command :'text_search/index_fact_data', fact_data: fact_data
  end

  after_update do |fact_data|
    return unless fact_data.changed?

    Pavlov.command :'text_search/index_fact_data',
                fact_data: fact_data,
                changed: fact_data.changed
  end

  after_destroy do |fact_data|
    Pavlov.command(:'text_search/delete_fact_data', object: fact_data)
  end

end
