module Facts
  class Fact < Mustache::Railstache

    def init
      self[:timestamp] ||= 0
    end

    def no_evidence_message
      if user_signed_in?
        "Perhaps you know something that supports or weakens this fact?"
      else
        "There are no Factlinks supporting or weakening this Factlink at the moment."
      end
    end

    def delete_from_channel_link
      remove_from_channel_path
    end

    def deletable_from_channel?
      user_signed_in? and self[:channel] and self[:channel].editable? and self[:channel].created_by == current_graph_user
    end

    def remove_from_channel_path
      if self[:channel]
        remove_fact_from_channel_path(current_user.username, self[:channel].id, self[:fact].id)
      end
    end

    def signed_in?
      user_signed_in?
    end

    def ajax_loader_image
      image_tag("ajax-loader.gif")
    end

    def evidence_search_path
      evidence_search_fact_path(self[:fact].id)
    end

    def prefilled_search_value
      params[:s] ? 'value="#{params[:s]}"' : ""
    end

    def id
      self[:fact].id
    end

    def displaystring
      self[:fact].data.displaystring
    end

    def modal?
      if self[:modal] != nil
        self[:modal]
      else
        false
      end
    end

    def fact_bubble
      Facts::FactBubble.for(fact: self[:fact], view: self.view).to_hash
    end

    def containing_channel_ids
      return [] unless current_graph_user
      current_graph_user.containing_channel_ids(self[:fact])
    end

    def last_active_users
      last_activity().map { |a| Users::User.for(user: a.user.user, view: self.view)}
    end

    expose_to_hash :timestamp

    private
      def last_activity(nr=3)
        Activity::For.fact(self[:fact]).sort_by(:created_at, limit: nr, order: "DESC")
      end
  end
end
