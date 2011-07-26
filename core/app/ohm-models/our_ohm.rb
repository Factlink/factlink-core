autoload :Basefact, 'basefact'
autoload :Fact, 'fact'
autoload :FactRelation, 'fact_relation'
autoload :GraphUser, 'graph_user'
autoload :OurOhm, 'our_ohm'
autoload :Site, 'site'

autoload :Opinion, 'opinion'
autoload :Opinionable, 'opinionable'
class OurOhm < Ohm::Model

  include Canivete::Deprecate
  
  def save!
    save
  end
  
  deprecate
  alias :new_record? :new?
  
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
    x
  end
  
end