module FactDataProxy
  
  def to_s
    self.displaystring || ""
  end
  
  #assuming we have a data
  def title
    self.require_data
    self.data.title
  end

  def title=(value)
    self.require_data
    self.data.title=value
  end

  def displaystring
    self.require_data
    self.data.displaystring
  end

  def displaystring=(value)
    self.require_data
    self.data.displaystring=value
  end 

  def content
    self.require_data
    self.data.content
  end

  def content=(value)
    self.require_data
    self.data.content=value
  end

  def passage
    self.require_data
    self.data.passage
  end

  def passage=(value)
    self.require_data
    self.data.passage=value
  end

  def created_at
    self.require_data
    self.data.created_at
  end

  def updated_at
    self.require_data
    self.data.updated_at
  end

end

class Fact < Basefact
  include Opinionable
  include FactDataProxy
  
  after :create, :set_activity!

  def set_activity!
    activity(self.created_by, "created", self)
  end

  reference :site, Site       # The site on which the factlink should be shown
  def url=(url)
    self.site = Site.find_or_create_by(:url => url)
  end
  def url
    self.site.url
  end
  # Return a nice looking url, only subdomain + domain + top level domain
  def pretty_url
    self.site.url.gsub(/http(s?):\/\//,'').split('/')[0]
  end

  reference :data, lambda { |id| FactData.find(id) }
  def require_data # dit ook doen met zo'n aftercreategebeuren    
    if not self.data_id
      localdata = FactData.new
      localdata.save    # FactData now has an ID
      self.data = localdata
      if self.save
        localdata.fact_id = self.id
        localdata.save
      else
        raise StandardException, "the object could not be saved, but this is required before a require_data can be executed"
      end
    end
  end
  
  def save_data
    self.data.save
  end

  after :save, :require_data
  after :save, :save_data


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
    supporting_facts | weakening_facts
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
      fr = FactRelation.get_or_create(evidence,type,self,user)
      activity(user,:created,fr)
      fr
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

  reference :evidence_opinion, Opinion
  reference :opinion, Opinion

  def calculate_evidence_opinion
    opinions = []
    [:supporting, :weakening].each do |type|
      factrelations = evidence(type)
      factrelations.each do |factrelation|
        opinions << factrelation.get_influencing_opinion
      end
    end
    self.evidence_opinion = Opinion.combine(opinions).save
    save
  end

  def get_evidence_opinion
    self.evidence_opinion || Opinion.identity
  end

  def calculate_opinion
    calculate_evidence_opinion
    total_opinion = self.get_user_opinion + self.get_evidence_opinion
    self.opinion = total_opinion.save
    save
  end
  
  def get_opinion
    self.opinion || Opinion.identity
  end
  
  def influencing_authority
    [FactRelation.find(:from_fact_id => self.id)
                .except(:created_by_id => gu.id)
                .count
     ,1].max
  end
  
end
