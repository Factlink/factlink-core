module Channels
  class Channel

    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @channel = options[:channel]
      @view = options[:view]
      @user = options[:channel_user] || @channel.created_by.user
      @topic_authority = options[:topic_authority]
      if @channel.topic
         @topic_authority ||= query_topic_authority(@channel.topic)
      end
      @user_stream_id = options[:user_stream_id] || query_user_stream_id
      @containing_channel_ids = options[:containing_channel_ids] || query_containing_channel_ids
    end

    #explicit implicit queries, should never be called
    def query_topic_authority(topic)
      Authority.from(topic , for: channel.created_by ).to_s.to_f + 1.0
    end

    def query_user_stream_id
      @user.graph_user.stream_id
    end

    def query_containing_channel_ids
      current_graph_user = @view.current_user.graph_user
      @channel.containing_channels_for(current_graph_user).ids
    end

    #accessors
    def channel
      @channel
    end

    def user
      @user
    end

    def current_user
      @view.current_user
    end

    def image_tag *args
      @view.image_tag(*args)
    end


    def topic_authority
      @topic_authority.andand.to_s
    end

    def user_stream_id
      @user_stream_id
    end

    def containing_channel_ids
      @containing_channel_ids
    end

    def to_hash
      is_created = (channel.type == 'created')
      is_all = (channel.type == 'stream')
      is_normal = !is_all && !is_created
      is_discover_stream = is_all && is_mine

      #DEPRECATED, CALCULATE THIS IN FRONTEND
      #SEE related_users_view.coffee
      is_mine = (user == current_user)

      title = if is_all
                'Stream'
              elsif is_created
                is_mine ? 'My Factlinks' : 'Created by ' + user.username
              else
                channel.title
              end

      long_title = if is_all
                     is_mine ? 'Stream' : "Stream of #{user.username}"
                   else
                     title
                   end

      unread_count = is_normal ? channel.unread_count : 0

      # no queries from here
      json = Jbuilder.new

      json.type channel.type
      json.is_created is_created
      json.is_all is_all

      json.is_mine is_mine
      json.id channel.id
      json.has_authority? channel.has_authority?

      json.add_channel_url '/' + user.username + '/channels/new'

      json.title title
      json.long_title long_title
      json.slug_title channel.slug_title

      json.is_normal is_normal


      json.created_by_authority topic_authority if topic_authority


      json.created_by do |j|
        j.id user.id
        j.username user.username
        j.avatar image_tag(user.avatar_url(size: 32), title: user.username, alt: user.username, width: 32)
        j.all_channel_id user_stream_id
      end

      json.discover_stream? is_discover_stream

      link = if is_discover_stream
              "/#{user.username}/channels/#{channel.id}/activities"
             else
              "/#{user.username}/channels/#{channel.id}"
             end
      json.link link
      json.edit_link link + "/edit"

      created_by_id = channel.created_by_id
      json.created_by_id created_by_id

      json.inspectable? channel.inspectable?
      json.followable?  !is_mine && is_normal
      json.editable?    is_mine && channel.editable?

      json.unread_count unread_count
      json.new_facts( (unread_count != 0) && is_mine )

      json.containing_channel_ids containing_channel_ids

      json.attributes!
    end
  end
end
