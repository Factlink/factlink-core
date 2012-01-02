class Fact < Basefact
  after :create, :set_activity!
  after :create, :add_to_created_facts

  def set_activity!
    activity(self.created_by, "created", self)
  end

  # TODO dirty, please decouple
  def add_to_created_facts
    self.created_by.created_facts_channel.add_fact(self)
  end

  def to_s
    self.data.displaystring || ""
  end

  reference :site, Site # The site on which the factlink should be shown

  reference :data, lambda { |id| id && FactData.find(id) }

  def require_saved_data
    if not self.data_id
      localdata = FactData.new
      localdata.save
      # FactData now has an ID
      self.data = localdata
    end
  end

  def set_own_id_on_saved_data
    self.data.fact_id = self.id
    self.data.save
  end

  before :create, :require_saved_data
  after :create, :set_own_id_on_saved_data


  set :supporting_facts, FactRelation
  set :weakening_facts, FactRelation

  def evidenced_factrelations
    FactRelation.find(:from_fact_id => self.id).all
  end

  def evidenced_facts
    evidenced_factrelations.map{|f| f.fact }
  end

  def self.by_display_string(displaystring)
    fd = FactData.where(:displaystring => displaystring)
    if fd.count > 0
      fd.first.fact
    else
      nil
    end
  end

  # Ohm Model needs to have a definition of which fields to render
  def to_hash
    return {} unless self.data
    super.merge(:_id => id,
                :displaystring => self.data.displaystring,
                :score_dict_as_percentage => get_opinion.as_percentages,
                :title => self.data.title)
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
    when :both
      return self.fact_relations
    end
  end

  def add_evidence(type, evidence, user)
    fr = FactRelation.get_or_create(evidence,type,self,user)
    activity(user,:created,fr)
    fr
  end

  #returns whether a given fact should be considered
  #unsuitable for usage/viewing
  def self.invalid(f)
    !f || !f.data_id
  end

  def delete
    delete_all_evidence
    delete_all_evidenced
    data.delete
    super
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

  attribute :cached_incluencing_authority
  def calculate_influencing_authority
    self.cached_incluencing_authority = [1, FactRelation.find(:from_fact_id => self.id).except(:created_by_id => self.created_by_id).count].max
    self.save
  end
  def influencing_authority
    [(self.cached_incluencing_authority.to_f || 1.0), 1.0].max
  end

end
