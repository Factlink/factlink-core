class FactData
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible []

  field :title,           type: String
  field :displaystring,   type: String
  field :site_url,        type: String # TODO: after SQL conversion call this "url"
  field :fact_id,         type: String

  index({ site_url: 1 })

  has_many :comments

  validates_format_of :displaystring, allow_nil: true, with: /\A.*\S.*\z/

  def url
    site_url
  end

  def to_s
    displaystring || ""
  end

  #returns whether a given factdata should be considered
  #unsuitable for usage/viewing
  def self.invalid(fd)
    not valid(fd)
  end

  def self.valid(fd)
    fd and fd.fact_id
  end

  def update_search_index
    fields = {displaystring: displaystring, title: title}
    ElasticSearch::Index.new('factdata').add id, fields
  end

  before_save do |fact_data|
    id_key = Nest.new('Fact')[:id]

    if fact_data.fact_id
      if fact_data.fact_id.to_i > id_key.get.to_i
        id_key.set fact_data.fact_id
      end
    else
      fact_data.fact_id = id_key.incr.to_s
    end
  end

  after_save do |fact_data|
    fact_data.update_search_index
  end

  after_destroy do |fact_data|
    Believable.new(Nest.new("Fact:#{fact_id}")).delete
    ElasticSearch::Index.new('factdata').delete fact_data.id

    fact_data.comments.each do |comment|
      comment.destroy
    end
  end
end
