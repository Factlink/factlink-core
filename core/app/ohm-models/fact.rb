module FactDataProxy
  
  def to_s
    self.displaystring || ""
  end
  
  #assuming we have a data
  def title
    require_data
    data.title
  end

  def title=(value)
    require_data
    data.title=value
  end

  def displaystring
    require_data
    data.displaystring
  end

  def displaystring=(value)
    require_data
    data.displaystring=value
  end 

  def content
    require_data
    data.content
  end

  def content=(value)
    require_data
    data.content=value
  end

  def passage
    require_data
    data.passage
  end

  def passage=(value)
    require_data
    data.passage=value
  end

  def created_at
    require_data
    data.created_at
  end

  def updated_at
    require_data
    data.updated_at
  end

  def require_data
    if not self.data_id
      localdata = FactData.new
      localdata.save    # FactData now has an ID
      self.data = localdata      
      save
      
      localdata.fact_id = self.id
      localdata.save
    end
  end

  def post_save
    require_data
    data.save
  end

end

class Fact < Basefact
  include FactDataProxy

  reference :data, lambda { |id| FactData.find(id) }

  set :supporting_facts, FactRelation
  set :weakening_facts, FactRelation
  
  def self.by_display_string(displaystring)
    fd = FactData.where(:displaystring => displaystring)
    if fd.count > 0
      fd.first.fact
    else
      nil
    end
  end
  
  # OHm Model needs to have a definition of which fields to render
  def to_hash
    super.merge(:_id => id, :displaystring => displaystring, :score_dict_as_percentage => score_dict_as_percentage)
  end
  
  deprecate
  def fact_relations_ids
    fact_relations.map { |fr| fr.id }
  end
  
  def fact_relations
    supporting_facts.all + weakening_facts.all
  end
  
  def sorted_fact_relations
    res = self.fact_relations.sort { |a, b| a.percentage <=> b.percentage }
    res.reverse
  end
  
  def evidence(type)
    case type
    when :supporting
      return self.supporting_facts
    when :weakening
      return self.weakening_facts
    end
    puts "Fact#evidence -- No evidence found for type '#{type}'"
  end

  def add_evidence(type, evidence, user)    
    # Some extra loop protection
    if evidence.id == self.id
      puts "[ERROR] Fact#add_evidence -- Failed creating a FactRelation because that would cause a loop!"
      return nil
    else
      FactRelation.get_or_create(evidence,type,self,user)
    end
  end
  
  # Count helpers
  def supporting_evidence_count
    evidence(:supporting).size
  end

  def weakening_evidence_count
    evidence(:weakening).size
  end

  def evidence_count
    weakening_evidence_count + supporting_evidence_count
  end
  
  # Used for sorting
  #deprecate
  def self.column_names
    FactData.column_names
  end

  def delete_cascading
    delete_data
    delete_all_evidence
    delete_all_evidenced
    self.delete
  end
  
  def delete_data
    data.delete
  end
  
  def delete_all_evidence
    fact_relations.each do |fr|
      fr.delete
    end
  end
  
  def delete_all_evidenced
    FactRelation.find(:from_fact_id => self.id).each do |fr|
      fr.delete
    end
  end

  private :delete_all_evidence, :delete_all_evidenced

  def evidence_opinion
    opinions = []
    [:supporting, :weakening].each do |type|
      factlinks = evidence(type)
      factlinks.each do |factlink|
        opinions << factlink.get_influencing_opinion
      end
    end
    Opinion.combine(opinions)
  end

  def get_opinion
    user_opinion = super
    user_opinion + evidence_opinion
  end

end
