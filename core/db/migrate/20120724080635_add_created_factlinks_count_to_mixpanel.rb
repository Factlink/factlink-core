class AddCreatedFactlinksCountToMixpanel < Mongoid::Migration
  def self.up
    mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.active.each do |user|
      gu = user.graph_user

      facts = gu.real_created_facts.to_a.keep_if { |f| f.site && f.site.url && not f.site.url.blank? }

      mixpanel.set_person_event user.id, factlinks_created_with_url: facts.length
    end
  end

  def self.down
  end
end
