class UserStream < Channel

  def add_fields
    self.title = "All"
    self.description = "All facts"
  end
  before :validate, :add_fields
  
  alias :graph_user :created_by

  def contained_channels
    created_by.internal_channels
  end
  
  def unread_count
    0
  end

  def discontinued
    false
  end
  
  def editable?
    false
  end
  
  def followable?
    false
  end

end