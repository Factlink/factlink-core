module Channels
  class Channel < Mustache::Railstache

    def init
      self[:user]||= self[:channel].created_by.user
    end

    def link
      if discover_stream?
        @link||="/#{self[:user].username}/channels/#{id}/activities"
      else
        @link||="/#{self[:user].username}/channels/#{id}"
      end
    end

    def edit_link
      link + "/edit"
    end

    def created_by_authority
      topic and (Authority.from(topic , for: self[:channel].created_by ).to_s.to_f + 1.0).to_s
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

    def discover_stream?
      is_all && is_mine
    end

    def created_by
      json = Jbuilder.new
      json.id self[:user].id
      json.username self[:user].username
      json.avatar image_tag(self[:user].avatar_url(size: 32), title: self[:user].username, alt: self[:user].username, width: 32)
      json.all_channel_id self[:user].graph_user.stream_id
      json.attributes!
    end

    def new_facts
      (unread_count != 0) && self[:user] == current_user
    end

    def id
      self[:channel].id
    end

    def slug_title
      self[:channel].slug_title
    end

    def containing_channel_ids
      self[:channel].containing_channels_for(current_graph_user).ids
    end

    def created_by_id
      self[:channel].created_by_id
    end

    def editable?
      current_graph_user.id == created_by_id && self[:channel].editable?
    end

    def followable?
      current_graph_user.id != created_by_id && is_normal
    end

    def inspectable?
       self[:channel].inspectable?
    end

    def unread_count
      @unread_count ||= is_normal ? self[:channel].unread_count : 0
    end

    private
      def topic
        @topic ||= if is_normal
                     self[:channel].topic
                   else
                     nil
                   end
      end

  end
end
