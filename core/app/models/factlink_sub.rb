class FactlinkSub < Votable
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongo::Voteable

  # set points for each vote

  # each vote on a comment can affect votes count and point of the related post as well
  # voteable FactlinkTop, :up => +20, :down => -10

  # include Sunspot::Mongoid   
  # Create search index on :displaystring
  # searchable do
  #   text :title
  # end

  field :title, :type => String
  field :content, :type => String
  field :url, :type => String

  belongs_to :factlink_top

  validates_presence_of :title, :on => :create, :message => "Please provide a title:"
  validates_presence_of :content, :on => :create, :message => "Please provide some content support this statement:"
  validates_presence_of :url, :on => :create, :message => "Please provide a url where the content can be found:"

  def score
    self.sum
  end
  
end