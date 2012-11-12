module Channels
  class Channel < Mustache::Railstache

    def init
      self[:user]||= self[:channel].created_by.user
    end

    def add_channel_url
      '/' + self[:user].username + '/channels/new'
    end

    def has_authority?
      self[:channel].has_authority?
    end

    def title
      if is_all
        'Stream'
      elsif is_created
        is_mine ? 'My Factlinks' : 'Created by ' + self[:user].username
      else
        self[:channel].title
      end
    end

    def long_title
      if is_all
        is_mine ? 'Stream' : "Stream of #{self[:user].username}"
      else
        title
      end
    end

    def type
      self[:channel].type
    end

    def is_created
      type == 'created'
    end

    def is_all
      type == 'stream'
    end

    def is_normal
      !is_all && !is_created
    end


    #DEPRECATED, CALCULATE THIS IN FRONTEND
    #SEE related_users_view.coffee
    def is_mine
      self[:user] == current_user
    end



    def id
      self[:channel].id
    end



    def to_hash
      channel = self[:channel]
      user = self[:user]

      json = Jbuilder.new

      if is_normal
        topic = channel.topic
        json.created_by_authority(Authority.from(topic , for: channel.created_by ).to_s.to_f + 1.0).to_s
      end

      json.created_by do |j|
        j.id self[:user].id
        j.username self[:user].username
        j.avatar image_tag(self[:user].avatar_url(size: 32), title: self[:user].username, alt: self[:user].username, width: 32)
        j.all_channel_id self[:user].graph_user.stream_id
      end

      json.slug_title channel.slug_title

      is_discover_stream = is_all && is_mine
      json.discover_stream? is_discover_stream

      link = if is_discover_stream
              "/#{user.username}/channels/#{id}/activities"
             else
              "/#{user.username}/channels/#{id}"
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
