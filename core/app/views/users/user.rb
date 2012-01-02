module Users
  class User < Mustache::Railstache
    def self.for_user(user, view)
      u = new(false)
      u[:user] = user
      u.view = view
      u.init
      return u
    end

    def initialize(run=true)
      init if run
    end

    def init
      self[:graph_user] = self[:user].graph_user
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

    def new_channel_button
      link_to("Add new", new_channel_path(current_user.username), :class => "btn small add-channel")
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
