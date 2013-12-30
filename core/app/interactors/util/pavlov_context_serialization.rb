module Util
  module PavlovContextSerialization

    module_function

    def pavlov_context_by_user user, ability=nil
      {
        current_user: user,
        ability: ability || Ability.new(user),
        mixpanel: FactlinkUI::Application.config.mixpanel.new({}, true)
      }
    end
  end
end
