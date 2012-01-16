module Users
  class User < Mustache::Railstache
    def init
      self[:graph_user] = self[:user].graph_user
    end

    def id
      self[:user].id
    end

    def graph_id
      self[:graph_user].id
    end

    def channels
      self[:graph_user].editable_channels
    end

    def username
      self[:user].username
    end

    def avatar(size=32)
      image_tag(self[:user].avatar.url(:small), :width => size)
    end

    def avatar_to_profile
      path = view.user_profile_path(self[:user].username)
      link_to(avatar_thumb, path, target: "_top" )
    end

    def avatar_thumb
      avatar(20)
    end

    def authority
      self[:graph_user].rounded_authority
    end

    def all_channel_id
      self[:graph_user].stream_id
    end

    def is_current_user
      self[:user] == current_user
    end

  end
end
