module Backend
  module Users
    extend self

    # This query returns dead user objects, retrieved by their ids
    # Please try to avoid to add support for all other kinds of fields,
    # both because we want it to have an index, and because we don't want to
    # leak too much of the internals
    def by_ids(user_ids:)
      user_ids = Array(user_ids)


      User.where(id: user_ids).map do |user|
        DeadUser.new \
          id: user.id.to_s,
          name: user.full_name.strip, # MAYBE It might be better to do strip on save
          username: user.username,
          avatar_url: Avatar.for_user(user),
          deleted: user.deleted
      end
    end

    # this method does more sanitation than you would expect
    # from a backend method, but it is sometimes called directly
    # with user input
    def user_by_username username: username
      return nil unless username.match /\A[A-Za-z0-9_]*\Z/i

      User.where(username: username.downcase).first
    end

    def delete(username:)
      user = user_by_username username: username
      mark_as_deleted user
      anonymize user
      remove_activities user
      remove_features user
    end

    def profile(username:)
      user = user_by_username username: username

      {
        location: nil_if_empty(user.location),
        biography: nil_if_empty(user.biography),
        followers_count: Backend::UserFollowers.follower_ids(followee_id: user.id).length,
        following_count: Backend::UserFollowers.followee_ids(follower_id: user.id).length,
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

      default_user = User.new
      User.personal_information_fields.each do |field|
        user[field] = default_user.attributes[field]
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

    def remove_activities user
      user.activities.destroy_all
      user.activities_with_user_as_subject.destroy_all
    end

    def remove_features user
      user.features.destroy_all
    end
  end
end
