class AddApprovedDateToApprovedUsers < Mongoid::Migration
  def self.up
    @mixpanel = FactlinkUI::Application.config.mixpanel.new({}, true)

    User.approved.each do |u|
      @mixpanel.set_person_event u.id.to_s, {
        approved_at: 3.weeks.ago
      }
    end
  end

  def self.down
  end
end
