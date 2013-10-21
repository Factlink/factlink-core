class Channel < OurOhm;end # needed because of removed const_missing from ohm
class Site < OurOhm; end # needed because of removed const_missing from ohm
class FactRelation < OurOhm;end # needed because of removed const_missing from ohm

class Fact < OurOhm
  include Activity::Subject
  include Pavlov::Helpers

  delegate :opinionated_users_ids, :opinionated_users_count, :opiniated, :add_opiniated, :remove_opinionateds,
           :people_believes, :people_doubts, :people_disbelieves,
           :to => :believable

  def validate
    assert_present :created_by
  end

  def create
    require_saved_data

    result = super

    set_activity!
    add_to_created_facts
    increment_mixpanel_count
    set_own_id_on_saved_data

    result
  end

  reference :created_by, GraphUser
  set :channels, Channel

  def increment_mixpanel_count
    return unless has_site? and created_by.user

    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)
    mixpanel.increment_person_event created_by.user.id.to_s, factlinks_created_with_url: 1
  end

  def set_activity!
    activity(created_by, :created, self)

    if created_by.created_facts.size == 1
      activity(created_by, :added_first_factlink , self)
    end
  end

  # TODO: dirty, please decouple
  def add_to_created_facts
    created_by.sorted_created_facts.add self
    channel = created_by.created_facts_channel

    command(:'channels/add_fact', fact: self, channel: channel)
  end

  def remove_from_created_facts
    created_by.sorted_created_facts.delete self
  end

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

  def self.build_with_data(url, displaystring, title, creator)
    site = url && (Site.find(url: url).first || Site.create(url: url))

    fact_params = {created_by: creator}
    fact_params[:site] = site if site
    fact = Fact.new fact_params
    fact.require_saved_data

    fact.data.displaystring = displaystring
    fact.data.title = title
    fact
  end

  def require_saved_data
    if not data_id
      localdata = FactData.new
      localdata.save
      # FactData now has an ID
      self.data = localdata
    end
  end

  def set_own_id_on_saved_data
    self.data.fact_id = id
    self.data.save
  end



  set :supporting_facts, FactRelation
  set :weakening_facts, FactRelation

  def evidenced_factrelations
    FactRelation.find(from_fact_id: id).all
  end

  def self.by_display_string(displaystring)
    fd = FactData.where(:displaystring => displaystring)
    if fd.count > 0
      fd.first.fact
    else
      nil
    end
  end

  def fact_relations
    supporting_facts | weakening_facts
  end

  def evidence(type=:both)
    return fact_relations if type == :both

    send(:"#{type}_facts")
  end

  def add_evidence(type, evidence, user)
    fr = FactRelation.get_or_create(evidence,type,self,user)
    activity(user.graph_user, :"added_#{type}_evidence", evidence, :to, self)
    fr
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


  def delete_data
    data.delete
  end

  def delete_all_evidence
    fact_relations.each do |fr|
      fr.delete
    end
  end

  def delete_all_evidenced
    FactRelation.find(from_fact_id: id).each do |fr|
      fr.delete
    end
  end

  # TODO: also remove yourself from channels, possibly using resque
  private :delete_all_evidence, :delete_all_evidenced, :delete_data

  def delete
    delete_data
    delete_all_evidence
    delete_all_evidenced
    believable.delete
    remove_from_created_facts
    super
  end

  def channel_ids
    channels.ids
  end
end
