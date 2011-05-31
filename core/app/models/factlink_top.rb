class FactlinkTop < Votable
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
  # field :score, :type => Hash, :default => {  :denies => 0, 
  #                                             :maybe => 120,
  #                                             :proves => 69 }
  
  # Score fields for easy access
  field :score_denies,  :type => Integer, :default => 14
  field :score_maybe,   :type => Integer, :default => 120
  field :score_proves,  :type => Integer, :default => 69
  
  # Relations
  belongs_to :site            # THe site on which the factlink should be shown
  has_many :factlink_subs     # The sub items

  # Validations
  validates_presence_of :displaystring
  

  def to_s
    displaystring
  end

  def subs
    self.factlink_subs
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
    (40 * absolute_score_proves) + (20 * absolute_score_maybe) - (50 * absolute_score_denies)
  end
  
end