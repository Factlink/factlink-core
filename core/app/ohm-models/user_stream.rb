class UserStream < Channel
  
  def initialize(attrs={})
    attrs.merge!({
      :title => "All",
      :description => "All facts",
    })
    super
  end
  
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