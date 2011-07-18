class OurOhm < Ohm::Model
  def save!
    save
  end
  
  deprecate
  def new_record?
    new?
  end
end