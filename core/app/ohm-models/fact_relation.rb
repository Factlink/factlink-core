class FactRelation < Basefact
  include Opinion::Subject::FactRelation
  include Ohm::ExtraValidations

  reference :from_fact, Fact
  reference :fact, Fact

  attribute :type # => :supporting || :weakening
  index :type

  def validate
    assert_present :from_fact_id
    assert_present :fact_id
    assert_present :type
    assert_member :type, [:supporting, :weakening, 'supporting', 'weakening']
    assert_unique [:from_fact_id, :fact_id, :type]
  end

  def FactRelation.get_or_create(from, type, to, user)
    id = get_id(from,type,to)
    if id
      FactRelation[id]
    else
      FactRelation.create_new(from,type,to, user)
    end
  end

  def FactRelation.get_by(from,type,to)
    FactRelation[get_id(from,type,to)]
  end

  def FactRelation.get_id(from,type,to)
    key['gcby'][from.id][type][to.id].get()
  end

  def FactRelation.create_new(from,type,to,user)
    fl = FactRelation.create(
      :created_by => user.graph_user,
      :from_fact => from,
      :fact => to,
      :type => type
    )

    unless fl.new?
      #TODO this should use a collection
      to.evidence(type) << fl
      key['gcby'][from.id][type][to.id].set(fl.id)
    end

    fl
  end

  def percentage
    if self.fact.get_opinion.weight == 0
      return 0
    else
      return (100 * self.get_influencing_opinion.weight / (self.fact.get_opinion.weight)).round.to_i
    end
  end

  def get_type_opinion
    Opinion.for_relation_type(self.type)
  end

  def deletable?
    EvidenceDeletable.new(self, self.class.to_s, believable, created_by_id).deletable?
  end

  def delete_key
    self.class.key['gcby'][from_fact.id][self.type][fact.id].del()
  end

  def delete_from_evidence
    fact.evidence(self.type.to_sym).delete(self)
  end

  before :delete, :delete_key
  before :delete, :delete_from_evidence
end
