class MoreMixpanelFields < Mongoid::Migration
  def self.up
    @mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.all.each do |u|
      @mixpanel.set_person_event u.id.to_s, {
        deleted: u.deleted,
        suspended: u.suspended,
        confirmed_at: u.confirmed_at
      }
    end
  end

  def self.down
  end
end
