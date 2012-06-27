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

    def topic_url
      topic and "/t/#{topic.slug_title}"
    end

    def add_channel_url
      '/' + self[:user].username + '/channels/new'
    end

    def has_authority?
      self[:channel].has_authority?
    end

    def activities_link
      link + "/activities"
    end

    def title
      if is_all
        is_mine ? 'My Stream' : 'Stream'
      elsif is_created
        is_mine ? 'My Factlinks' : 'Created by ' + self[:user].username
      else
        self[:channel].title
      end
    end

    def long_title
      if is_all
        is_mine ? 'My Stream' : self[:user].username.possessive+ ' Stream'
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

    def is_mine
      self[:user] == current_user
    end

    def discover_stream?
      is_all && is_mine
    end

    def created_by
      {
        id: self[:user].id,
        username: self[:user].username,
        avatar: image_tag(self[:user].avatar_url(size: 32), title: self[:user].username, alt: self[:user].username, width: 32),
        all_channel_id: self[:user].graph_user.stream_id
      }
    end

    def new_facts
      (unread_count != 0) && self[:user] == current_user
    end

    def id
      self[:channel].id
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
      @unread ||= if can_haz :new_read_counter
          if is_normal
            self[:channel].new_unread_count
          else
            0
          end
        else
          self[:channel].unread_count
        end
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
