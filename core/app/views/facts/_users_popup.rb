module Facts
    class UsersPopup < Mustache::Rails
    
    
      def to_hash
        { :graph_users => graph_users, }
      end
    end
end