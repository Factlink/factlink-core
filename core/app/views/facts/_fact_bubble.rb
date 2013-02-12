module Facts
  class FactBubble
    def self.for(*args)
      new(*args)
    end

    def initialize options={}
      @fact = options[:fact]
      @view = options[:view]
    end

    def to_hash
      # DEPRECATED: PLEASE REMOVE ASAP
      begin
        proxy_scroll_url = FactlinkUI::Application.config.proxy_url + "/?url=" + CGI.escape(@fact.site.url) + "&scrollto=" + URI.escape(@fact.id)
      rescue
        proxy_scroll_url = nil
      end

      displaystring = @view.send(:h, @fact.data.displaystring)
      link = @view.link_to(displaystring, proxy_scroll_url, :target => "_blank")
      # / DEPRECATED

      json = JbuilderTemplate.new(@view)

      json.link link
      json.fact_id @fact.id
      json.url @view.friendly_fact_path(@fact)
      json.id @fact.id

      base = BaseViews::FactBubbleBase.new @fact, @view
      base.add_to_json json

      json.attributes!
    end
  end
end
