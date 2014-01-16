class Channel < OurOhm;end # needed because of removed const_missing from ohm
class Site < OurOhm; end # needed because of removed const_missing from ohm
class FactRelation < OurOhm;end # needed because of removed const_missing from ohm

class Fact < OurOhm
  include Pavlov::Helpers

  delegate :opinionated_users_ids, :opiniated, :add_opiniated, :remove_opinionateds,
           :to => :believable

  def validate
    assert_present :created_by
  end

  def create
    require_saved_data

    result = super

    add_to_created_facts
    set_own_id_on_saved_data

    result
  end

  reference :created_by, GraphUser
  set :channels, Channel

  def has_site?
    site and site.url and not site.url.blank?
  end

  def to_s
    data.displaystring || ""
  end

  def created_at
    data.created_at.utc.to_s if data
  end

  reference :site, Site # The site on which the factlink should be shown

  reference :data, ->(id) { id && FactData.find(id) }

  def require_saved_data
    return if data_id

    localdata = FactData.new
    localdata.save
    # FactData now has an ID
    self.data = localdata
  end

  def add_evidence(type, evidence, user)
    FactRelation.get_or_create(evidence,type,self,user)
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

  #returns whether a given fact should be considered
  #unsuitable for usage/viewing
  def self.invalid(f)
    !f || !f.data_id
  end

  def delete
    fail "Cannot be deleted" unless deletable?

    data.delete
    believable.delete
    remove_from_created_facts
    super
  end

  def deletable?
    opinionated_users_ids - [created_by_id] == [] &&
      FactRelation.find(fact_id: id).count == 0 &&
      FactRelation.find(from_fact_id: id).count == 0
  end

  private

  # TODO: dirty, please decouple
  def add_to_created_facts
    created_by.sorted_created_facts.add self
  end

  def remove_from_created_facts
    created_by.sorted_created_facts.delete self
  end

  def set_own_id_on_saved_data
    data.fact_id = id
    data.save!
  end
end
