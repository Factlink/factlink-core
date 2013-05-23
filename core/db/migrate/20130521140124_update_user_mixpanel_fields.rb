class UpdateUserMixpanelFields < Mongoid::Migration
  def self.up
    @mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.active.each do |u|
      @mixpanel.set_person_event u.id.to_s, {
        receives_mailed_notifications: u.receives_mailed_notifications,
        receives_digest: u.receives_digest,
        location: u.location,
        biography: u.biography
      }
    end
  end

  def self.down
  end
end
