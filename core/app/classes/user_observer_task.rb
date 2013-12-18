class UserObserverTask
  def self.handle_changes user
    changed_mixpaneled_fields = user.changed & User.mixpaneled_fields.keys

    return unless changed_mixpaneled_fields.length > 0 ||
                  user.set_up_changed? && user.set_up?

    fields = user.attributes
                 .slice( *User.mixpaneled_fields.keys )
                 .each_with_object({}) do |(k,v), memo|
                   memo[User.mixpaneled_fields[k]] = v
                 end

    mixpanel.set_person_event user.id.to_s, fields
  end

  private

  def self.mixpanel
    FactlinkUI::Application.config.mixpanel.new({}, true)
  end
end
