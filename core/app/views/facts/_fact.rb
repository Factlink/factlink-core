module Facts
  class Fact
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

    def url
      @view.friendly_fact_path(@fact)
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

    def proxy_scroll_url
      FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(@fact.site.url) + "&scrollto=" + URI.escape(@fact.id)
    rescue
      nil
    end

    def to_hash
      json = JbuilderTemplate.new(@view)

      json.displaystring @fact.data.displaystring
      json.id @fact.id
      json.site_id @fact.site_id
      json.containing_channel_ids containing_channel_ids
      json.url url

      if @channel
        json.deletable_from_channel? deletable_from_channel?
        # TODO : this should be moved to view logic in the frontend,
        #        however, because of the strong coupling with channel
        #        this isn't trivial, so I decided to postpone this for
        #        now, as this might also change in the future (maybe
        #        'repost' will always suffice for instance)
        post_action = @fact.created_by == @channel.created_by ? 'Posted' : 'Reposted'
        json.post_action post_action

        timestamp_in_seconds = @timestamp / 1000
        friendly_time = TimeFormatter.as_time_ago(timestamp_in_seconds)
        json.friendly_time friendly_time
      end

      json.created_by created_by
      json.created_by_ago created_by_ago

      json.fact_title @fact.data.title
      json.fact_wheel do |j|
        j.partial! partial: 'facts/fact_wheel',
                      formats: [:json], handlers: [:jbuilder],
                      locals: { fact: @fact }
      end
      json.fact_url(@fact.has_site? ? @fact.site.url : nil)
      json.proxy_scroll_url proxy_scroll_url

      json.timestamp @timestamp

      json.attributes!
    end

  end
end
