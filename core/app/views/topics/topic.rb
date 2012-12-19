module Topics
  class Topic
    def self.for *args
      t = new(*args)
      if t.channels.length > 0
        t
      else
        nil
      end
    end

    def initialize options={}
      @topic = options[:topic]
      @view = options[:view]
    end

    def title
      @topic.title
    end

    def channels
      @channels ||= @topic.top_users(3).map do |user|
        channel = user.graph_user.internal_channels.find(slug_title: @topic.slug_title).first

        {
          channel: channel,
          user: user
        }
      end.keep_if do |hash|
        hash[:channel]
      end.map do |hash|
        {
          user_name: hash[:user].username,
          user_profile_url: @view.user_profile_path(hash[:user]),
          channel_url: @view.channel_path(hash[:user],hash[:channel]),
          avatar_url: hash[:user].avatar_url,
          authority: sprintf('%.1f',Authority.from(@topic,for: hash[:user].graph_user).to_f+1.0)
        }
      end
    end

    def to_hash
      json = Jbuilder.new
      json.title title
      json.channels channels
      json.attributes!
    end
  end
end
