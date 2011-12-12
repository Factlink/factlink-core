module Facts
  class FactBubble < Mustache::Railstache
    def self.for_fact_and_view(fact, view, channel=nil, modal=nil)
      fb = new
      fb.view = view
      fb[:channel] = channel
      fb[:fact] = fact
      fb[:modal] = modal
      return fb
    end
    
    def user_signed_in?
      self.view.user_signed_in?
    end

    def i_am_fact_owner
      (self[:fact].created_by == current_graph_user)
    end

    def editable_title_class
      (user_signed_in? and i_am_fact_owner) ? " edit " : ""
    end

    def scroll_to_link
      show_links ? link_to(pretty_url, self[:fact].site.url, :target => "_blank") : pretty_url
    end

    def link
      displaystring = h self[:fact].data.displaystring
      show_links ? link_to(displaystring, proxy_scroll_url, :target => "_blank") : displaystring
    end
  
    def last_activity
      activity = self[:fact].activities(1)[0]
      activity && link_to(activity.user.user.username, user_profile_path(activity.user.user.username), target: "_top") + " " + activity.action + " " + time_ago_in_words(activity.created_at) + " ago"
    end
    
    def fact_title
      self[:fact].data.title
    end
    
    def fact_id
      self[:fact].id
    end
    
    def fact_wheel
      Facts::FactWheel.for_fact_and_view(self[:fact], self.view)
    end
    
    def to_hash
      {
        :fact_id => fact_id,
        :editable_title_class => editable_title_class,
        :fact_title => fact_title,
        :link => link,
        :scroll_to_link => scroll_to_link,
        :last_activity => last_activity,
        :user_signed_in? => user_signed_in?,
        :i_am_fact_owner => i_am_fact_owner,
        :fact_wheel => fact_wheel,
      }
    end
    
    private
      def show_links
        not (self[:hide_links_for_site] and  self[:fact].site == self[:hide_links_for_site]) and self[:fact].site
      end
      
      def proxy_scroll_url
        FactlinkUI::Application.config.proxy_url + "/?url=" + URI.escape(self[:fact].site.url) + "&scrollto=" + URI.escape(self[:fact].id)
      end
      
      def pretty_url
        if self[:fact].site
          self[:fact].site.url.gsub(/http(s?):\/\//,'').split('/')[0]
        else
          ""
        end
      end
      
      def link_for(gu)
        imgtag = image_tag(gu.user.avatar.url(:small), :size => "24x24", :title => "#{gu.user.username} (#{gu.rounded_authority})")
        path = view.user_profile_path(gu.user.username)
        link_to( imgtag, path, :target => "_top" )
      end
  end
end
