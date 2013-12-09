class MigrateUnsetInviteFields
  @queue = :aaa_migration

  def self.perform user_id
    user = User.find(user_id)

    invite_fields = [
      :invitation_token,
      :invitation_sent_at,
      :invitation_accepted_at,
      :invitation_limit,
      :invited_by_id,
      :invited_by_type
    ]

    invite_fields.each do |invite_field|
      user.unset invite_field
    end
  end
end
