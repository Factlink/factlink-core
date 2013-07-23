require 'ohm/contrib'

class FactRelation < Basefact
  include Ohm::ExtraValidations
  include Ohm::Timestamping

  attr_accessor :sub_comments_count

  reference :from_fact, Fact
  reference :fact, Fact

  attribute :type # => :supporting || :weakening
  index :type

  reference :influencing_opinion, Opinion

  def validate
    assert_present :from_fact_id
    assert_present :fact_id
    assert_present :type
    assert_member :type, [:supporting, :weakening, 'supporting', 'weakening']
    assert_unique [:from_fact_id, :fact_id, :type]
  end

  def self.get_or_create(from, type, to, user)
    id = get_id(from,type,to)
    if id
      self[id]
    else
      create_new(from,type,to, user)
    end
  end

  def self.get_id(from,type,to)
    key['gcby'][from.id][type][to.id].get
  end

  def self.create_new(from,type,to,user)
    fact_relation = FactRelation.create(
      created_by: user.graph_user,
      from_fact: from,
      fact: to,
      type: type
    )
    raise "Creating FactRelation went wrong" if fact_relation.new?

    #TODO this should use a collection
    to.evidence(type) << fact_relation
    key['gcby'][from.id][type][to.id].set(fact_relation.id)

    fact_relation
  end
  private_class_method :create_new, :get_id

  def get_type_opinion
    Opinion.for_type(OpinionType.for_relation_type(type))
  end

  def deletable?
    EvidenceDeletable.new(self, self.class.to_s, believable, created_by_id).deletable?
  end

  def delete_key
    self.class.key['gcby'][from_fact.id][self.type][fact.id].del
  end

  def delete_from_evidence
    fact.evidence(self.type).delete(self)
  end

  before :delete, :delete_key
  before :delete, :delete_from_evidence
end
