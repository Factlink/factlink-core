module BaseViews
  class FactBubbleBase
    def initialize fact, view
      @fact = fact
      @view = view
    end

    def add_to_json json
      i_am_fact_owner = (@fact.created_by == @view.current_graph_user)
      can_edit = (@view.user_signed_in? and i_am_fact_owner)

      json.user_signed_in? user_signed_in?
      json.i_am_fact_owner i_am_fact_owner
      json.can_edit? can_edit
      json.scroll_to_link scroll_to_link
      json.displaystring @fact.data.displaystring
      json.fact_title fact_title
      json.fact_wheel do |j|
        j.partial! partial: 'facts/fact_wheel',
                      formats: [:json], handlers: [:jbuilder],
                      locals: { fact: @fact }
      end
      # DEPRECATED, use fact_wheel (or not, but choose one)
      json.believe_percentage @fact.get_opinion.as_percentages[:believe][:percentage]
      json.disbelieve_percentage @fact.get_opinion.as_percentages[:disbelieve][:percentage]
      json.doubt_percentage @fact.get_opinion.as_percentages[:doubt][:percentage]
      # / DEPRECATED
      json.fact_url(@fact.has_site? ? @fact.site.url : nil)
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

    def scroll_to_link
      if fact_title
        @view.link_to(fact_title, proxy_scroll_url, :target => "_blank")
      elsif not fact_title.blank?
        fact_title
      else
        nil
      end
    end

    def fact_title
      @fact.data.title
    end

  end
end
