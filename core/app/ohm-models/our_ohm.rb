require 'ohm/contrib'

class OurOhm < Ohm::Model
   include Ohm::Contrib
   include Ohm::Callbacks
   extend ActiveModel::Naming
   include Canivete::Deprecate
   
   # needed for Ohm polymorphism:
   self.base = self
   
   class << self
     alias :create! :create
   end


  alias save! save

  deprecate
  alias :new_record? :new?

  def self.find_or_create_by(opts)
    self.find(opts).first || self.create(opts)
  end

end

class Ohm::Model::Set < Ohm::Model::Collection
  alias :count :size
  
  def &(other)
    apply(:sinterstore,key,other.key,key+"*INTERSECT*"+other.key)
  end

  def |(other)
    apply(:sunionstore,key,other.key,key+"*UNION*"+other.key)
  end

  def -(other)
    apply(:sdiffstore,key,other.key,key+"*DIFF*"+other.key)
  end
  
end

class Ohm::Model::List < Ohm::Model::Collection
  alias :count :size
end