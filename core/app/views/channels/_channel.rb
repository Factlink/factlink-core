module Channels
  class Channel < Mustache::Railstache

    def init
      self[:user]||= self[:channel].created_by.user
    end

    def to_hash
      channel = self[:channel]
      user = self[:user]

      json = Jbuilder.new


      type = channel.type
      json.type type


      is_created = (type == 'created')
      json.is_created is_created
      is_all = (type == 'stream')
      json.is_all is_all


      #DEPRECATED, CALCULATE THIS IN FRONTEND
      #SEE related_users_view.coffee
      is_mine =       user == current_user
      json.is_mine is_mine


      json.id channel.id

      json.has_authority? channel.has_authority?

      json.add_channel_url '/' + user.username + '/channels/new'


      title = if is_all
                'Stream'
              elsif is_created
                is_mine ? 'My Factlinks' : 'Created by ' + user.username
              else
                channel.title
              end
      json.title title

      long_title = if is_all
                     is_mine ? 'Stream' : "Stream of #{user.username}"
                   else
                     title
                   end
      json.long_title = long_title


      is_normal = !is_all && !is_created
      json.is_normal is_normal

      if is_normal
        topic = channel.topic
        json.created_by_authority(Authority.from(topic , for: channel.created_by ).to_s.to_f + 1.0).to_s
      end

      json.created_by do |j|
        j.id user.id
        j.username user.username
        j.avatar image_tag(user.avatar_url(size: 32), title: user.username, alt: user.username, width: 32)
        j.all_channel_id user.graph_user.stream_id
      end

      json.slug_title channel.slug_title

      is_discover_stream = is_all && is_mine
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
      json.followable?  current_graph_user.id != created_by_id && is_normal
      json.editable?    current_graph_user.id == created_by_id && channel.editable?

      unread_count = is_normal ? channel.unread_count : 0
      json.unread_count unread_count
      json.new_facts( (unread_count != 0) && user == current_user )

      json.containing_channel_ids channel.containing_channels_for(current_graph_user).ids

      super.merge json.attributes!
    end

  end
end
