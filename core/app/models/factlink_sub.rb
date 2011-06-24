class FactlinkSub
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, :type => String
  field :content, :type => String
  field :url, :type => String

  belongs_to :factlink_top  
  belongs_to :created_by, :class_name => "User"

  validates_presence_of :title, 
                        :on => :create, 
                        :message => "Please provide a title:"

  validates_presence_of :content, 
                        :on => :create, 
                        :message => "Please provide some content support this statement:"


  validates_format_of :url, 
                      :with => URI::regexp(%w(http https)), 
                      :on => :create, 
                      :message => "Please provide a valid url where the content can be found:", 
                      :allow_nil => false

  def score
    self.votes_point
  end
  
  def voted_up_by_user?(user)
    self.up_voter_ids.include?(user.id)
  end
  
  def voted_down_by_user?(user)
    self.down_voter_ids.include?(user.id)
  end
  
end