module Util
  module PavlovContextSerialization

    module_function

    def serialize_pavlov_context pavlov_context
      return nil unless pavlov_context[:current_user]

      {'serialize_id' => pavlov_context[:current_user].id.to_s}
    end

    def deserialize_pavlov_context pavlov_context
      pavlov_context_by_user_id pavlov_context['serialize_id']
    end

    def pavlov_context_by_user_id user_id
      pavlov_context_by_user User.find(user_id)
    end

    def pavlov_context_by_user user
      {
        current_user: user,
        ability: Ability.new(user),
        mixpanel: FactlinkUI::Application.config.mixpanel.new({}, true),
        facebook_app_namespace: FactlinkUI::Application.config.facebook_app_namespace
      }
    end
  end
end
