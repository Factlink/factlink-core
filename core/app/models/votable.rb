class Votable
  include Mongoid::Document
  
  UpVote = +1
  DownVote = -2

  field :up_sum,        :type => Integer, :default => 0
  field :down_sum,      :type => Integer, :default => 0
  field :up_count,      :type => Integer, :default => 0
  field :down_count,    :type => Integer, :default => 0
  field :sum,           :type => Integer, :default => 0
  field :count,         :type => Integer, :default => 0

  default_scope desc(:sum)

  def vote_up
    self.up_sum = self.up_sum + UpVote
    self.sum = self.sum + UpVote
    self.up_count = self.up_count + 1
    self.count = self.count + 1
    self.save
    return true
  end
  
  def vote_down
    self.down_sum = self.down_sum + DownVote
    self.sum = self.sum + DownVote
    self.down_count = self.down_count + 1
    self.count = self.count + 1
    self.save
    return true
  end

end