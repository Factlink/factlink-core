class AddAllUsersToMixpanel < Mongoid::Migration
  def self.up
    @mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.active.each do |u|
      @mixpanel.set_person_event u.id, {
        first_name: u.first_name,
        last_name: u.last_name,
        username: u.username,
        email: u.email,
        created: u.created_at,
        last_login: u.last_sign_in_at
      }
    end
  end

  def self.down
  end
end
