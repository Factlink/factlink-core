module Facts
    class RemoteForm < Mustache::Rails
      def id
        self[:fact].id
      end

      def channel_path
        channels_path(@current_user.username) 
      end
    
    end
end