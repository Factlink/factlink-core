class Votable
  include Mongoid::Document
  
  UpVote = +1
  DownVote = +1

  # Sum of the up and down votes (when using + or - other then 1)
  field :up_sum,        :type => Integer, :default => 0
  field :down_sum,      :type => Integer, :default => 0

  # Number of up and down votes
  field :up_count,      :type => Integer, :default => 0
  field :down_count,    :type => Integer, :default => 0

  # Total sum
  field :sum,           :type => Integer, :default => 0
  # Total number of votes
  field :count,         :type => Integer, :default => 0

  default_scope desc(:sum)

  def vote_up
    self.up_sum = self.up_sum + 1
    self.up_count = self.up_count + 1

    self.sum = self.sum + 1    
    self.count = self.count + 1

    self.save
    return true
  end
  
  def vote_down
    self.down_sum = self.down_sum + 1
    self.down_count = self.down_count + 1

    self.sum = self.sum - 1
    self.count = self.count + 1
    self.save
    return true
  end

end