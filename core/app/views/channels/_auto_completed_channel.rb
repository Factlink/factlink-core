module Channels
  class AutoCompletedChannel < Mustache::Railstache
    def title
      self[:topic].title
    end

    def slug_title
      self[:topic].slug_title
    end

    def user_channel
      ch = ::Channel.find(created_by_id: current_graph_user.id, slug_title: title.to_url).first

      if ch
        Channel.for(channel: ch, view: self).to_hash
      else
        false
      end
    end
  end
end
