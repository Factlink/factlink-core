require 'ohm/contrib'

class FactRelation < Basefact
  include Opinion::Subject::FactRelation
  include Ohm::ExtraValidations
  include Ohm::Timestamping

  attr_accessor :sub_comments_count

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

  def self.get_or_create(from, type, to, user)
    id = get_id(from,type,to)
    if id
      FactRelation[id]
    else
      FactRelation.create_new(from,type,to, user)
    end
  end

  def self.get_by(from,type,to)
    FactRelation[get_id(from,type,to)]
  end

  def self.get_id(from,type,to)
    key['gcby'][from.id][type][to.id].get()
  end

  def self.create_new(from,type,to,user)
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
    return 0 if fact.get_opinion.authority == 0

    part = get_influencing_opinion.authority / fact.get_opinion.authority

    (100 * part).round.to_i
  end

  def get_type_opinion
    Opinion.for_type(OpinionType.for_relation_type(type))
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
