module Facts
  class Fact
    include BaseViews::FactBubbleBase

    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @channel = options[:channel]
      @modal = options[:modal]
      @view = options[:view]

      @timestamp = options[:timestamp] || 0
    end

    def displaystring
      @fact.data.displaystring
    end

    def id
      @fact.id
    end

    def site_id
      @fact.site_id
    end

    def signed_in?
      user_signed_in?
    end

    def containing_channel_ids
      return [] unless @view.current_graph_user
      @view.current_graph_user.containing_channel_ids(@fact)
    end

    def deletable_from_channel?
      user_signed_in? and @channel and @channel.editable? and @channel.created_by == @view.current_graph_user
    end

    def i_am_owner
      (@fact.created_by == @view.current_graph_user)
    end

    def modal?
      if @modal != nil
        @modal
      else
        false
      end
    end

    def fact_base
      Facts::FactBubble.for(fact: @fact, view: @view).to_hash
    end

    def url
      @view.friendly_fact_path(@fact)
    end

    def post_action
      if @channel
        if @fact.created_by == @channel.created_by #current_user
          'Posted'
        else
          'Reposted'
        end
      end
    end

    def friendly_time
      return nil unless @channel

      timestamp_in_seconds = @timestamp / 1000


      TimeFormatter.as_time_ago timestamp_in_seconds
    end

    def created_by
      user = @fact.created_by.user

      json = JbuilderTemplate.new(@view)
      json.partial! partial: "users/user_authority_for_subject_partial",
                    formats: [:json],
                    handlers: [:jbuilder],
                    locals: {
                      user: user,
                      subject: @fact
                    }
      json.attributes!
    end

    def created_by_ago
      "Created #{TimeFormatter.as_time_ago @fact.data.created_at} ago"
    end

    def believers_count
      @fact.opiniated(:believes).count
    end
    def disbelievers_count
      @fact.opiniated(:disbelieves).count
    end
    def doubters_count
      @fact.opiniated(:doubts).count
    end

    def to_hash
      json = Jbuilder.new

      json.displaystring displaystring
      json.id id
      json.site_id site_id
      json.signed_in? signed_in?
      json.containing_channel_ids containing_channel_ids
      json.deletable_from_channel? deletable_from_channel?
      json.i_am_owner i_am_owner
      json.modal? modal?
      json.fact_base fact_base
      json.url url
      json.post_action post_action
      json.friendly_time friendly_time
      json.created_by created_by
      json.created_by_ago created_by_ago
      json.believers_count believers_count
      json.disbelievers_count disbelievers_count
      json.doubters_count doubters_count
      json.timestamp = @timestamp

      json.user_signed_in? user_signed_in?
      json.i_am_fact_owner i_am_fact_owner
      json.can_edit? can_edit?
      json.scroll_to_link scroll_to_link
      json.displaystring displaystring
      json.fact_title fact_title
      json.fact_wheel fact_wheel
      json.believe_percentage believe_percentage
      json.disbelieve_percentage disbelieve_percentage
      json.doubt_percentage doubt_percentage
      json.fact_url fact_url
      json.proxy_scroll_url proxy_scroll_url

      json.attributes!
    end
  end
end
