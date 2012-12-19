module Users
  class User
    def self.for *args
      new(*args)
    end

    def initialize options={}
      @user = options[:user]
      @graph_user = @user.graph_user
      @view = options[:view]
    end

    def id
      @user.id
    end

    def graph_id
      @graph_user.id
    end

    # TODO should render User view or similar, but will infinitely recurse if
    # also containing a Users:User view
    def channels
      @graph_user.editable_channels_by_authority(4)
    end

    def name
      @user.name.blank? ? username : @user.name
    end

    def username
      @user.username
    end

    def location
      nil_if_empty(@user.location)
    end

    def biography
      nil_if_empty(@user.biography)
    end

    def gravatar_hash
      Gravatar.hash(@user.email)
    end

    def avatar(size=32)
      @view.image_tag(@user.avatar_url(size: size), :width => size, :height => size, :alt => @user.username)
    end

    def avatar_thumb
      avatar(20)
    end

    def all_channel_id
      @graph_user.stream_id
    end

    def created_facts_channel_id
      @graph_user.created_facts_channel_id
    end

    def is_current_user
      @user == @view.current_user
    end

    def receives_mailed_notifications
      @user.receives_mailed_notifications
    end

    def to_hash
      json = Jbuilder.new

      json.id id
      json.graph_id graph_id
      json.channels channels
      json.name name
      json.username username
      json.location location
      json.biography biography
      json.gravatar_hash gravatar_hash
      json.avatar avatar(size=32)
      json.avatar_thumb avatar_thumb
      json.all_channel_id all_channel_id
      json.created_facts_channel_id created_facts_channel_id
      json.is_current_user is_current_user
      json.receives_mailed_notifications receives_mailed_notifications

      json.attributes!
    end

    private
      def nil_if_empty x
        x.blank? ? nil : x
      end

  end
end
