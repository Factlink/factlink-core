class Channel < OurOhm
  
  attribute :title
  attribute :description
  
  set :facts, Fact
  
  reference :user, GraphUser
  
  def validate
    assert_present :title
    # assert_present :user # User always needed?
  end
  
end