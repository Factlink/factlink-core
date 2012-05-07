module Notifications
  class NewChannel < Mustache::Railstache


  	def channel_title
  		self[:activity].subject.title
  	end

    def channel_url
      channel_path(self[:activity].subject.graph_user.user, self[:activity].subject.id)
    end

  end
end
