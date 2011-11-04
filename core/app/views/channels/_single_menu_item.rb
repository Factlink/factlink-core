module Channels
  class SingleMenuItem < Mustache::Railstache

    def link
      get_facts_for_channel_path(self[:channel].created_by.user.username, self[:channel].id)
    end
  
    def title
      self[:channel].title
    end
  
    def nr_of_facts
      self[:channel].unread_count
    end
  
    def new_facts
      (self[:channel].unread_count != 0) 
    end

    def id
      self[:channel].id
    end
  
    def to_hash
      return {
                 :id => id,
               :link => link,
              :title => title,
            :new_facts => new_facts,
        :nr_of_facts => nr_of_facts,
      }
    end
  end
  
end
