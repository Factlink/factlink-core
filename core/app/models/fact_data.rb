class FactData
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  include Sunspot::Mongoid

  searchable :auto_index => true do
    text    :displaystring
    string  :displaystring
    time    :created_at
  end

  field :title,           :type => String
  field :displaystring,   :type => String   # For matching Fact on a page
  field :passage,         :type => String   # Passage for matching: not implemented
  field :content,         :type => String   # Source content
  field :fact_id,         :type => String

  def self.column_names
    self.fields.collect { |field| field[0] }
  end

  def to_s
    self.displaystring || ""
  end
  
  
    
  def fact
    if fact_id
      puts "\n\nReturning Fact with id #{fact_id}"
      return Fact[fact_id]
    else
      
      puts "\n\nCreating new Fact"
      new_fact = Fact.new
      new_fact.save
  
      self.fact = new_fact
  
      new_fact.data = self
      new_fact.save
      return new_fact
    end
  end
  
  def fact=(the_fact)
    self.fact_id = the_fact.id
    self.save
  end
  
end