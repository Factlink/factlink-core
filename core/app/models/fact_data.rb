class FactData < ActiveRecord::Base
  # TODO: already choose a good database name here
  # TODO: after SQL conversion call "site_url" "url" ?
  attr_accessible :displaystring, :fact_id, :site_url, :title

  # attr_accessible []
  # For compatibility with Activity::Listener
  def self.[](fact_id)
    FactData.where(fact_id: fact_id).first
  end

  #index({ site_url: 1 })

  has_many :comments

  validates_format_of :displaystring, allow_nil: true, with: /\A.*\S.*\z/m

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
    fd
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
    FactDataInteresting.where(fact_data_id: fact_data.id)
                       .each { |interesting| interesting.destroy }

    ElasticSearch::Index.new('factdata').delete fact_data.id

    fact_data.comments.each do |comment|
      comment.destroy
    end
  end
end
