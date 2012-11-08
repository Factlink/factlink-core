module BaseViews
  module FactBase
    def displaystring
      self[:fact].data.displaystring
    end

    def id
      self[:fact].id
    end

    def channels_definition
      t(:channels).titleize
    end

    def nr_of_supporting_facts
      self[:fact].supporting_facts.size
    end

    def nr_of_weakening_facts
      self[:fact].weakening_facts.size
    end

    def interacting_users
      if self[:show_interacting_users]
        Facts::InteractingUsers.for(fact: self[:fact], view: self.view, user_count: interacting_user_count).to_hash
      else
        {activity: []}
      end
    end

    def signed_in?
      user_signed_in?
    end

    def containing_channel_ids
      return [] unless current_graph_user
      current_graph_user.containing_channel_ids(self[:fact])
    end

    private

    def interacting_user_count
      3
    end
  end
end
