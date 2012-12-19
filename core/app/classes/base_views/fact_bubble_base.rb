module BaseViews
  class FactBubbleBase
    def initialize fact, view
      @fact = fact
      @view = view
    end

    def add_to_json json
      json.user_signed_in? user_signed_in?
      json.i_am_fact_owner i_am_fact_owner
      json.can_edit? can_edit?
      json.scroll_to_link scroll_to_link
      json.displaystring displaystring
      json.fact_title fact_title
      json.fact_wheel do |j|
        fact_wheel j
      end
      json.believe_percentage believe_percentage
      json.disbelieve_percentage disbelieve_percentage
      json.doubt_percentage doubt_percentage
      json.fact_url fact_url
      json.proxy_scroll_url proxy_scroll_url
    end

    def user_signed_in?
      @view.user_signed_in?
    end

    def proxy_scroll_url
      FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(@fact.site.url) + "&scrollto=" + URI.escape(@fact.id)
    rescue
      ""
    end

    private

    def i_am_fact_owner
      (@fact.created_by == @view.current_graph_user)
    end

    def can_edit?
      @view.user_signed_in? and i_am_fact_owner
    end

    def scroll_to_link
      if fact_title
        @view.link_to(fact_title, proxy_scroll_url, :target => "_blank")
      elsif not fact_title.blank?
        fact_title
      else
        nil
      end
    end

    def displaystring
      @fact.data.displaystring
    end

    def fact_title
      @fact.data.title
    end

    def fact_wheel json
      json.partial! partial: 'facts/fact_wheel', formats: [:json], handlers: [:jbuilder], locals: { fact: @fact }
    end

    # DEPRECATED, use fact_wheel (or not, but choose one)
    def believe_percentage
      @fact.get_opinion.as_percentages[:believe][:percentage]
    end

    # DEPRECATED, use fact_wheel (or not, but choose one)
    def disbelieve_percentage
      @fact.get_opinion.as_percentages[:disbelieve][:percentage]
    end

    # DEPRECATED, use fact_wheel (or not, but choose one)
    def doubt_percentage
      @fact.get_opinion.as_percentages[:doubt][:percentage]
    end

    def fact_url
      if @fact.has_site?
        @fact.site.url
      else
        nil
      end
    end


  end
end
