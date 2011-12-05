module Users
  class User < Mustache::Railstache
    def self.for_user(graph_user, view)
      u = new(false)
      u.view = view
      u[:user] = graph_user.user
      u[:graph_user] = graph_user
      u.init

      return u
    end
    
    def initialize(run=true)
      init if run
    end

    def init

    end
    
    def id
      self[:user].id
    end
    
    def username
      self[:user].username
    end
    
    def avatar
      image_tag(self[:user].avatar.url(:small), :width => 32)
    end
    
    def authority
      self[:graph_user].rounded_authority
    end
    
    def all_channel_id
      self[:graph_user].stream.id
    end
    
    def to_hash
      return {
                    :id => id,
                :avatar => avatar,
              :username => username,
             :authority => authority,
        :all_channel_id => all_channel_id,
      }
    end
  end
end
