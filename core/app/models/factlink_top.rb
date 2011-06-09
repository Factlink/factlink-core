class FactlinkTop
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  # include Sunspot::Mongoid
  # Create search index on :displaystring
  # searchable do
    # text :displaystring
  # end

  # Fields
  field :displaystring
  
  # Score fields for easy access
  field :score_denies,  :type => Integer, :default => 1
  field :score_maybe,   :type => Integer, :default => 1
  field :score_proves,  :type => Integer, :default => 1
  
  # Relations
  belongs_to :site            # The site on which the factlink should be shown
  belongs_to :created_by, :class_name => "User"
  has_many :factlink_subs     # The sub items

  # Validations
  validates_presence_of :displaystring
    
  def update_score
    self.score_proves = (self.factlink_subs.map { |s| s.up_votes_count }.inject(0) { |result, value | result + value  })
    self.score_denies = 10 #(self.factlink_subs.map { |s| s.down_votes_count }.inject(0) { |result, value | result + value  })
    self.score_maybe = ((self.score_proves + self.score_denies) / 2)
    self.save
  end
  
  def to_s
    displaystring
  end

  def score_dict_as_percentage
    percentage_score_dict = {}

    percentage_score_dict['denies'] = ((100 * self.score_denies) / total_score)
    percentage_score_dict['maybe'] = ((100 * self.score_maybe) / total_score)
    percentage_score_dict['proves'] = ((100 * self.score_proves) / total_score)

    percentage_score_dict
  end

  def score_dict_as_absolute
    absolute_score_dict = {}

    absolute_score_dict['denies'] = self.score_denies
    absolute_score_dict['maybe'] = self.score_maybe
    absolute_score_dict['proves'] = self.score_proves

    absolute_score_dict
  end

  def total_score
    # Sum all values and return the result
    # Start with result of 1 against devised by 0 error
    [self.score_denies, self.score_maybe, self.score_proves].inject(1) { | result, value | result + value }
  end

  # Percentual scores
  def percentage_score_denies
    score_dict_as_percentage['denies']
  end
  
  def percentage_score_maybe
    score_dict_as_percentage['maybe']
  end
  
  def percentage_score_proves
    score_dict_as_percentage['proves']
  end

  # Absolute scores
  def absolute_score_denies
    self.score_denies
  end
  
  def absolute_score_maybe
    self.score_maybe
  end
  
  def absolute_score_proves
    self.score_proves
  end
  
  # Stats count
  def stats_count
    # Fancy score calculation
    (10 * absolute_score_proves) + (10 * absolute_score_maybe) - (10 * absolute_score_denies)
  end
  
end