module Subchannels
  class SubchannelItem < Mustache::Railstache
    def self.for_channel_and_view(channel,view)
      si = new
      si.view = view
      si[:channel] = channel
      si[:user] = channel.created_by.user
      return si
    end
    
    def id
      self[:channel].id
    end
    
    def link
      channel_path self[:user].username, self[:channel].id
    end
    
    def user_avatar
       self[:user].avatar.url
    end
    
    def username
       self[:user].username
    end
    
    def title
      self[:channel].title
    end
    
    def to_hash
      return {
                 :id => id,
               :link => link,
              :title => title,
           :username => username,
        :user_avatar => user_avatar,
      }
    end
  end
end
