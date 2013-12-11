class FactRelation < OurOhm
  include Activity::Subject

  attr_accessor :sub_comments_count

  attribute :created_at
  attribute :updated_at

  reference :from_fact, Fact
  reference :fact, Fact
  reference :created_by, GraphUser

  attribute :type # => :believes || :disbelieves
  index :type

  delegate :opinionated_users_ids, :opiniated, :add_opiniated, :remove_opinionateds,
           :people_believes, :people_doubts, :people_disbelieves,
           :to => :believable

  def validate
    assert_present :from_fact_id
    assert_present :fact_id
    assert_present :type
    assert_member :type, [:believes, :disbelieves, 'believes', 'disbelieves']
    assert_unique [:from_fact_id, :fact_id, :type]
    assert_present :created_by
  end

  def self.get_or_create(from, type, to, user)
    find(type: type, fact_id: to.id, from_fact_id: from.id).first or
      create_new(from, type, to, user)
  end

  def self.create_new(from,type,to,user)
    fact_relation = FactRelation.create(
      created_by: user.graph_user,
      from_fact: from,
      fact: to,
      type: type
    )
    fail "Creating FactRelation went wrong" if fact_relation.new?

    fact_relation
  end
  private_class_method :create_new

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
    believable.delete
    super
  end

  def believable
    @believable ||= Believable.new(key)
  end

  def add_opinion(type, user)
    add_opiniated(type,user)
  end

  def remove_opinions(user)
    remove_opinionateds(user)
  end

  def to_s
    from_fact.to_s
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
