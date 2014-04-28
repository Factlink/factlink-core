class FactData < ActiveRecord::Base
  include PgSearch

  multisearchable against: [:displaystring, :title]
  pg_search_scope :search_by_content, against: [:displaystring, :title]

  # TODO: already choose a good database name here
  attr_accessible :displaystring, :fact_id, :site_url, :title, :created_by_id

  #index({ site_url: 1 })

  has_many :comments
  belongs_to :group

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

  before_save do |fact_data|
    id_key = Nest.new('Fact')[:id]

    if fact_data.fact_id
      if fact_data.fact_id.to_i > id_key.get.to_i
        id_key.set fact_data.fact_id
      end
    else
      fact_data.fact_id = id_key.incr.to_i
    end
  end

  after_destroy do |fact_data|
    FactDataInteresting.where(fact_data_id: fact_data.id)
                       .each { |interesting| interesting.destroy }

    fact_data.comments.each do |comment|
      comment.destroy
    end
  end
end
