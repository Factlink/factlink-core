module Backend
  module Users
    extend self

    # This query returns dead user objects, retrieved by their ids
    # You have the option to call it with mongo ids, or with (Ohm) GraphUser
    # ids.
    # Please try to avoid to add support for all other kinds of fields,
    # both because we want it to have an index, and because we don't want to
    # leak too much of the internals
    def by_ids(user_ids:, by: nil)
      by ||= :_id
      user_ids = Array(user_ids)

      fail "invalid id type: #{by}" unless [:_id, :graph_user_id].include? by


      User.any_in(by => user_ids).map do |user|
        DeadUser.new \
          id: user.id.to_s,
          name: user.name,
          username: user.username,
          gravatar_hash: user.gravatar_hash,
          deleted: user.deleted
      end
    end

    # this method does more sanitation than you would expect
    # from a backend method, but it is sometimes called directly
    # with user input
    def user_by_username username: username
      return nil unless username.match /\A[A-Za-z0-9_]*\Z/i

      User.find_by(username: /^#{username.downcase}$/i)
    end

    def delete(username:)
      user = user_by_username username: username
      mark_as_deleted user
      anonymize user
    end

    def profile(username:)
      user = user_by_username username: username

      {
        location: nil_if_empty(user.location),
        biography: nil_if_empty(user.biography),
        followers_count: UserFollowingUsers.new(user.graph_user_id).followers_count,
        following_count: UserFollowingUsers.new(user.graph_user_id).following_count,
      }
    end

    private

    def nil_if_empty x
      x.blank? ? nil : x
    end

    def mark_as_deleted user
      user.deleted = true
      user.save!
    end

    def anonymize user
      return unless user.deleted

      User.personal_information_fields.each do |field|
        user[field] = User.fields[field].default_val
      end

      user.full_name = 'Deleted User'

      anonymous_username = 'anonymous_' + SecureRandom.hex[0..9]
      anonymous_password = SecureRandom.hex

      user.username = anonymous_username
      user.email = "deleted+#{anonymous_username}@factlink.com"
      # TODO: at some point we can use an official invalid address (check RFCs)
      # For now we want to easily see what mails deleted users still get

      user.password              = anonymous_password
      user.password_confirmation = anonymous_password

      user.save!

      user.social_accounts.each do |social_account|
        # TODO: properly deauthorize facebook here
        social_account.destroy
      end
    end
  end
end
