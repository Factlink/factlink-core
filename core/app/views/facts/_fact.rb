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
      @view.user_signed_in?
    end

    def containing_channel_ids
      return [] unless @view.current_graph_user

      channel_list = ChannelList.new(@view.current_graph_user)
      channel_list.containing_channel_ids_for_fact @fact
    end

    def deletable_from_channel?
      signed_in? and @channel and @channel.is_real_channel? and @channel.created_by == @view.current_graph_user
    end

    def i_am_owner
      (@fact.created_by == @view.current_graph_user)
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
      json = JbuilderTemplate.new(@view)

      json.displaystring displaystring
      json.id id
      json.site_id site_id
      json.signed_in? signed_in?
      json.containing_channel_ids containing_channel_ids
      json.deletable_from_channel? deletable_from_channel?
      json.i_am_owner i_am_owner
      json.fact_base fact_base
      json.url url
      json.post_action post_action
      json.friendly_time friendly_time
      json.created_by created_by
      json.created_by_ago created_by_ago
      json.believers_count believers_count
      json.disbelievers_count disbelievers_count
      json.doubters_count doubters_count

      base = BaseViews::FactBubbleBase.new @fact, @view
      base.add_to_json json

      json.timestamp @timestamp

      json.attributes!
    end
  end
end
