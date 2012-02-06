module Channels
  class SingleMenuItem < Mustache::Railstache

    def init
      self[:user]||= self[:channel].created_by.user
    end

    def link
      @link||="/#{self[:user].username}/channels/#{id}"
    end

    def edit_link
      link + "/edit"
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

    def created_by
      Users::User.for(user: self[:user], view: self.view)
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
      current_graph_user.id != created_by_id
    end

    def inspectable?
       self[:channel].inspectable?
    end

    def unread_count
      @unread ||= self[:channel].unread_count
    end

  end
end
