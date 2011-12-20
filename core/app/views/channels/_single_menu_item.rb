module Channels
  class SingleMenuItem < Mustache::Railstache

    def self.for_channel_and_view(channel,view,channel_user=nil)
      smi = new(false)
      smi.view = view
      smi[:channel] = channel
      smi[:user] = channel_user
      smi.init
      return smi
    end

    def initialize(run=true)
      init if run
    end

    def init
      self[:user]||= self[:channel].created_by.user
    end

    def link
      #channel_path(self[:user].username, id)
      @link||="/#{self[:user].username}/channels/#{id}/"
    end
    
    def edit_link
      link + "edit"
    end
  
    def title
      self[:channel].title
    end

    def type
      self[:channel].type
    end
    
    def created_by
      Users::User.for_user(self[:user], self.view)
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
