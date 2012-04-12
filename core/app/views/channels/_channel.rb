module Channels
  class Channel < Mustache::Railstache

    def init
      self[:user]||= self[:channel].created_by.user
    end

    def link
      @link||="/#{self[:user].username}/channels/#{id}"
    end

    def edit_link
      link + "/edit"
    end

    def personalized_authority
      topic and (Authority.from(topic , for: self[:channel].created_by ).to_s.to_f + 1.0).to_s
    end

    def topic_url
      topic and "/t/#{topic.slug_title}"
    end

    def has_authority?
      self[:channel].has_authority?
    end

    def brain_icon
      @@brain_png ||= image_tag image_path("brain.png")
    end

    def activities_link
      link + "/activities"
    end

    def title
      self[:channel].title
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

    def created_by
      {
        id: self[:user].id,
        username: self[:user].username,
        avatar: image_tag(self[:user].avatar_url(size: 32), :width => 32),
        all_channel_id: self[:user].graph_user.stream_id
      }
    end

    def nr_of_facts
      unread_count
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
      @unread ||= self[:channel].unread_count
    end

    def channel_definition
      t(:channel)
    end

    def channels_definition
      t(:channels)
    end

    def add_to_channels_definition
      t(:add_to_channels).capitalize
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
