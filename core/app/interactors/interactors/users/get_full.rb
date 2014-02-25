module Interactors
  module Users
    class GetFull
      include Pavlov::Interactor
      include Util::CanCan

      private

      arguments :username

      def execute
        normal_properties.merge current_user_properties
      end

      def user
        @user ||= query(:'user_by_username', username: username) || fail('not found')
      end

      def current_user
        pavlov_options[:current_user]
      end

      def authorized?
        true
      end

      def nil_if_empty x
        x.blank? ? nil : x
      end

      def normal_properties
        {
          id:                            user.id.to_s,
          name:                          user.name,
          username:                      user.username,
          gravatar_hash:                 user.gravatar_hash,
          deleted: user.deleted,

          statistics_follower_count: UserFollowingUsers.new(user.graph_user_id).followers_count,
          statistics_following_count: UserFollowingUsers.new(user.graph_user_id).following_count,

          location: nil_if_empty(user.location),
          biography: nil_if_empty(user.biography)
        }
      end

      def current_user_properties
        return {} unless user == current_user

        {
          is_current_user: true,
          receives_mailed_notifications: user.receives_mailed_notifications,
          receives_digest: user.receives_digest,
          confirmed: user.confirmed?,
          created_at: user.created_at,
          services: services,
          features: interactor(:'global_features/all') + user.features.to_a
        }
      end

      def services
        {}.tap do |services|
          if can?(:share_to, user.social_account('twitter'))
            services[:twitter] = true
          end

          if can?(:share_to, user.social_account('facebook'))
            services[:facebook] = true
            services[:facebook_expires_at] = user.social_account('facebook').expires_at
          end
        end
      end

      def validate
        validate_nonempty_string :username, username
      end
    end
  end
end
