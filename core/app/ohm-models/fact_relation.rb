class FactRelation < OurOhm
  include Activity::Subject

  attr_accessor :sub_comments_count

  attribute :created_at
  attribute :updated_at

  reference :from_fact, Fact
  reference :fact, Fact
  reference :created_by, GraphUser

  attribute :type # => :supporting || :weakening
  index :type

  delegate :opinionated_users_ids, :opinionated_users_count, :opiniated, :add_opiniated, :remove_opinionateds,
           :people_believes, :people_doubts, :people_disbelieves,
           :to => :believable

  def validate
    assert_present :from_fact_id
    assert_present :fact_id
    assert_present :type
    assert_member :type, [:supporting, :weakening, 'supporting', 'weakening']
    assert_unique [:from_fact_id, :fact_id, :type]
    assert_present :created_by
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

  def create
    self.created_at ||= Time.now.utc.to_s

    super
  end

  def get_type_opinion
    Opinion.for_type(OpinionType.for_relation_type(type))
  end

  def deletable?
    EvidenceDeletable.new(self, self.class.to_s, believable, created_by_id).deletable?
  end

  def delete
    self.class.key['gcby'][from_fact.id][self.type][fact.id].del
    fact.evidence(self.type).delete(self)
    believable.delete
    super
  end

  def believable
    @believable ||= Believable.new(self.key)
  end

  def add_opinion(type, user)
    add_opiniated(type,user)
  end

  def remove_opinions(user)
    remove_opinionateds(user)
  end

  private

  def assert_member(att, set, error = [att, :not_member])
    assert set.include?(send(att)), error
  end

  protected

  def write
    self.updated_at = Time.now.utc.to_s

    super
  end
end
