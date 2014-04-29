class FactData < ActiveRecord::Base
  include PgSearch

  multisearchable against: [:displaystring, :title]
  pg_search_scope :search_by_content, against: [:displaystring, :title]

  # TODO: already choose a good database name here
  attr_accessible :displaystring, :fact_id, :site_url, :title, :created_by_id

  #index({ site_url: 1 })

  belongs_to :group
  has_many :fact_data_interestings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, as: :subject, dependent: :destroy

  validates_format_of :displaystring, allow_nil: true, with: /\A.*\S.*\z/m

  def url
    site_url
  end

  def to_s
    displaystring || ""
  end

  before_save do |fact_data|
    fact_data.fact_id ||= (self.class.maximum(:fact_id) || 0) + 1
  end
end
