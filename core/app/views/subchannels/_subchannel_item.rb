module Subchannels
  class SubchannelItem < Mustache::Railstache
    def self.for_channel_and_view(channel,view,channel_user=nil)
      si = new(false)
      si.view = view
      si[:channel] = channel
      si[:user] = channel_user
      si.init
      return si
    end

    def initialize(run=true)
      init if run
    end

    def init
      self[:user]||= self[:channel].created_by.user
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
               :link => link,
              :title => title,
           :username => username,
        :user_avatar => user_avatar,
      }
    end
  end
end
