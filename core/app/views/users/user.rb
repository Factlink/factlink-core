module Users
  class User < Mustache::Railstache
    @cache = {}

    def init
      self[:graph_user] = self[:user].graph_user
    end

    def id
      self[:user].id
    end

    def graph_id
      self[:graph_user].id
    end

    # TODO should render User view or similar, but will infinitely recurse if
    # also containing a Users:User view
    def channels
      self[:graph_user].editable_channels_by_authority(4)
    end

    def username
      self[:user].username
    end

    def location
      self[:user].location
    end

    def biography
      self[:user].biography
    end

    def avatar(size=32)
      image_tag(self[:user].avatar_url(size: size), :width => size, :height => size, :alt => self[:user].username)
    end

    def avatar_thumb
      avatar(20)
    end

    def profile_path
      view.user_profile_path(self[:user].username)
    end

    #DEPRECATED
    def authority
      "?"
    end

    def all_channel_id
      self[:graph_user].stream_id
    end

    def is_current_user
      self[:user] == current_user
    end


  end
end
