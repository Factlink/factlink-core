class UserNotification
  include Mongoid::Document
  embedded_in :user

  field :notification_settings_edit_token, type: String
end
