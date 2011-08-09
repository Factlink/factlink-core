class Channel < OurOhm
  
  attribute :title
  attribute :description
  
  collection :facts, Fact
  
  reference :user, GraphUser
  
end