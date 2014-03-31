class FactData
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible []

  field :title,           type: String
  field :displaystring,   type: String
  field :site_url,        type: String
  field :fact_id,         type: String

  index({ site_url: 1 })

  has_many :comments

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

  def update_search_index
    fields = {displaystring: displaystring, title: title}
    ElasticSearch::Index.new('factdata').add id, fields
  end

  after_save do |fact_data|
    fact_data.update_search_index
  end

  after_destroy do |fact_data|
    ElasticSearch::Index.new('factdata').delete fact_data.id

    fact_data.comments.each do |comment|
      comment.destroy
    end
  end
end
