class Channel < OurOhm;end # needed because of removed const_missing from ohm
class Site < OurOhm; end # needed because of removed const_missing from ohm
class FactRelation < Basefact;end # needed because of removed const_missing from ohm

class Fact < Basefact
  include Opinion::Subject::Fact
  include Pavlov::Helpers

  after :create, :set_activity!
  after :create, :add_to_created_facts
  after :create, :increment_mixpanel_count

  set :channels, Channel

  timestamped_set :interactions, Activity

  def increment_mixpanel_count
    if self.has_site? and self.created_by.user
      mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

      mixpanel.increment_person_event self.created_by.user.id.to_s, factlinks_created_with_url: 1
    end
  end

  def set_activity!
    activity(self.created_by, :created, self)

    if self.created_by.created_facts.size == 1
      activity(self.created_by, :added_first_factlink , self)
    end
  end

  # TODO dirty, please decouple
  def add_to_created_facts
    channel = self.created_by.created_facts_channel

    command :'channels/add_fact', channel
  end

  def has_site?
    self.site and not self.site.url.andand.blank?
  end

  def to_s
    self.data.displaystring || ""
  end

  reference :site, Site # The site on which the factlink should be shown

  reference :data, lambda { |id| id && FactData.find(id) }

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

  def evidence(type=:both)
    return fact_relations if type == :both

    send(:"#{type}_facts")
  end

  def add_evidence(type, evidence, user)
    fr = FactRelation.get_or_create(evidence,type,self,user)
    activity(user.graph_user, :"added_#{type}_evidence", evidence, :to, self)
    fr
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
    FactRelation.find(:from_fact_id => self.id).each do |fr|
      fr.delete
    end
  end

  #TODO also remove yourself from channels, possibly using resque
  before :delete, :delete_data
  before :delete, :delete_all_evidence
  before :delete, :delete_all_evidenced
  private :delete_all_evidence, :delete_all_evidenced, :delete_data

  def channel_ids
    channels.map {|ch| ch.id}
  end

  include OurOhm::RedisTopFunctionality
  def top_score
    self.get_opinion().a
  end
  def self.top_key
    Fact.key[:top_facts]
  end
  def self.top_instance id
    Fact[id]
  end
  before :delete, :remove_from_top

end
