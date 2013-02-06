module BaseViews
  class FactBubbleBase
    def initialize fact, view
      @fact = fact
      @view = view
    end

    def add_to_json json
      begin
        proxy_scroll_url = FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(@fact.site.url) + "&scrollto=" + URI.escape(@fact.id)
      rescue
        proxy_scroll_url = nil
      end

      user_signed_in = @view.user_signed_in?

      fact_title =  @fact.data.title

      i_am_fact_owner = (@fact.created_by == @view.current_graph_user)
      can_edit = (user_signed_in and i_am_fact_owner)

      json.user_signed_in? user_signed_in
      json.i_am_fact_owner i_am_fact_owner
      json.can_edit? can_edit
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

  end
end
