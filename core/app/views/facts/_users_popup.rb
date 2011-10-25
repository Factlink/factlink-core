module Facts
    class UsersPopup < Mustache::Rails
      def graph_users_with_link
        self[:graph_users].map do |gu|
          {
            :username => gu.user.username,
            :link => link_for(gu),
          }
        end
      end
    
      def link_for(gu)
        link_to(
          image_tag(gu.user.avatar, :size => "24x24", :title => "#{gu.user.username} (#{gu.rounded_authority})"),
          user_profile_path(gu.user.username), :target => "_top" )
      end
    
      def to_hash
        { :graph_users => graph_users, }
      end
    end
end