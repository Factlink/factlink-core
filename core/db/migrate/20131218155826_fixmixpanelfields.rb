class Fixmixpanelfields < Mongoid::Migration
  def self.up
    @mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.active.each do |u|
      @mixpanel.set_person_event u.id.to_s, {
        name: u.full_name,
        username: u.username
      }
    end
  end

  def self.down
  end
end
