class GraphUser < OurOhm
  reference :data, lambda { |id| (id && User.find(id)) || User.create }

  # Authority of the user
  def authority
    1.0
  end
  set :facts, Fact
  
end