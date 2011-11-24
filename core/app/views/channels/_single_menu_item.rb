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
      channel_path(self[:user].username, self[:channel].id)
    end
    
    def edit_link
      edit_channel_path(self[:channel].created_by.user.username, id)
    end
  
    def title
      self[:channel].title
    end

    def type
      self[:channel].type
    end
    
    def show_subchannels?
      editable? || followable?
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
  
    def created_by_id
      self[:channel].created_by_id
    end
    
    def editable?
      current_user.graph_user == self[:channel].created_by && self[:channel].editable?
    end
    
    def followable?
      current_user.graph_user != self[:channel].created_by && self[:channel].followable?
    end
  
    def to_hash
      return {
#                       |
#                      ()
#                      |
                   :id => id,
                 :link => link,
                 :type => type,
                :title => title,
            :edit_link => edit_link,
            :new_facts => new_facts,
          :followable? => followable?,
            :editable? => editable?,
          :nr_of_facts => nr_of_facts,
        :created_by_id => created_by_id,
    :show_subchannels? => show_subchannels?,
      }
    end

    def unread_count
      @unread ||= self[:channel].unread_count
    end

  end
end
