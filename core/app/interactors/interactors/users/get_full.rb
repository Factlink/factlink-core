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
        @user ||= Backend::Users.user_by_username(username: username) || fail('not found')
      end

      def current_user
        pavlov_options[:current_user]
      end

      def authorized?
        can? :show, user
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

          statistics_follower_count: profile[:followers_count],
          statistics_following_count: profile[:following_count],

          location: profile[:location],
          biography: profile[:biography]
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
          full_name: user.full_name,
          email: user.email,
          services: services,
          features: interactor(:'global_features/all') + user.features.to_a
        }
      end

      def services
        {}.tap do |services|
          if user.social_account('twitter').persisted?
            services[:twitter] = true
          end

          if user.social_account('facebook').persisted?
            services[:facebook] = true
          end
        end
      end

      def profile
        @profile ||= Backend::Users.profile(username: username)
      end

      def validate
        validate_nonempty_string :username, username
      end
    end
  end
end
