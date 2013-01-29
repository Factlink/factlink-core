class AddCreatedFactlinksCountToMixpanel < Mongoid::Migration
  def self.up
    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.active.each do |user|
      facts = facts_for(user.graph_user)

      mixpanel.set_person_event user.id.to_s,
                 factlinks_created_with_url: facts.length
    end
  end

  def self.facts_for gu
    gu.created_facts.find_all { |fact| fact.class == Fact }
      .to_a.select { |f| f.has_site? }
  end

  def self.down
  end
end
