module Facts
  class Fact < Mustache::Railstache
    include BaseViews::FactBubbleBase

    def init
      self[:timestamp] ||= 0
    end

    def displaystring
      self[:fact].data.displaystring
    end

    def id
      self[:fact].id
    end

    def site_id
      self[:fact].site_id
    end

    def signed_in?
      user_signed_in?
    end

    def containing_channel_ids
      return [] unless current_graph_user
      current_graph_user.containing_channel_ids(self[:fact])
    end

    def deletable_from_channel?
      user_signed_in? and self[:channel] and self[:channel].editable? and self[:channel].created_by == current_graph_user
    end

    def i_am_owner
      (self[:fact].created_by == current_graph_user)
    end

    def modal?
      if self[:modal] != nil
        self[:modal]
      else
        false
      end
    end

    def fact_base
      Facts::FactBubble.for(fact: self[:fact], view: self.view).to_hash
    end

    def url
      friendly_fact_path(self[:fact])
    end

    def post_action
      if self[:channel]
        if self[:fact].created_by == self[:channel].created_by #current_user
          'Posted'
        else
          'Reposted'
        end
      end
    end

    def friendly_time
      return nil unless self[:channel]

      timestamp_in_seconds = self[:timestamp] / 1000


      TimeFormatter.as_time_ago timestamp_in_seconds
    end

    expose_to_hash :timestamp

    # imported from extended fact:
    def created_by
      user = self[:fact].created_by.user

      json = JbuilderTemplate.new(self.view)
      json.partial! partial: "users/user_authority_for_subject_partial",
                    formats: [:json],
                    handlers: [:jbuilder],
                    locals: {
                      user: user,
                      subject: self[:fact]
                    }
      json.attributes!
    end

    def created_by_ago
      "Created #{TimeFormatter.as_time_ago self[:fact].data.created_at} ago"
    end

    def believers_count
      self[:fact].opiniated(:believes).count
    end
    def disbelievers_count
      self[:fact].opiniated(:disbelieves).count
    end
    def doubters_count
      self[:fact].opiniated(:doubts).count
    end
  end
end
