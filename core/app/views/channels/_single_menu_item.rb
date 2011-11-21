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
      get_facts_for_channel_path(self[:user].username, self[:channel].id)
    end
  
    def title
      self[:channel].title
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
  
    def to_hash
      return {
#                    /\
#                    |
                 :id => id,
               :link => link,
              :title => title,
          :new_facts => new_facts,
        :nr_of_facts => nr_of_facts,
      :created_by_id => created_by_id,
      }
    end

    def unread_count
      @unread ||= self[:channel].unread_count
    end

  end
end
