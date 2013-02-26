module Facts
  class Fact
    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @channel = options[:channel]
      @view = options[:view]

      @timestamp = options[:timestamp] || 0
    end

    def containing_channel_ids
      return [] unless @view.current_graph_user

      channel_list = ChannelList.new(@view.current_graph_user)
      channel_list.containing_real_channel_ids_for_fact @fact
    end

    def deletable_from_channel?
      @view.user_signed_in? and @channel and @channel.is_real_channel? and @channel.created_by == @view.current_graph_user
    end

    def fact_base
      Facts::FactBubble.for(fact: @fact, view: @view).to_hash
    end

    def url
      @view.friendly_fact_path(@fact)
    end

    # TODO : this should be moved to view logic in the frontend,
    #        however, because of the strong coupling with channel
    #        this isn't trivial, so I decided to postpone this for
    #        now, as this might also change in the future (maybe
    #        'repost' will always suffice for instance)
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

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.displaystring @fact.data.displaystring
      json.id @fact.id
      json.site_id @fact.site_id
      json.containing_channel_ids containing_channel_ids
      json.deletable_from_channel? deletable_from_channel?
      json.fact_base fact_base
      json.url url
      json.post_action post_action
      json.friendly_time friendly_time
      json.created_by created_by
      json.created_by_ago created_by_ago

      base = BaseViews::FactBubbleBase.new @fact, @view
      base.add_to_json json

      json.timestamp @timestamp

      json.attributes!
    end
  end
end
