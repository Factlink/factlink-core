class OurOhm < Ohm::Model
  def save!
    save
  end
  
  deprecate
  alias :new_record? :new?
  
  alias :object_id :id
  alias :_id :id
    
  
  def save
    pre_save
    super
    post_save
  end
  
  def pre_save
  end
  
  def post_save
  end
  
  deprecate
  def self.create!(*args)
    x = self.new(*args)
    x.save
  end
end