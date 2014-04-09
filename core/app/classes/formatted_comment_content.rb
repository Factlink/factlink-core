class FormattedCommentContent
  include ActionView::Helpers::TagHelper

  def initialize text
    @text = text
  end

  def html
    urls_to_link_tags ERB::Util.html_escape(@text).to_str
  end

  private

  def urls_to_link_tags text
    auto_link_re = %r{(?:(?<scheme>http|https)://|www\.)[^\s<\u00A0]+}i
    application_url = URI.join(FactlinkUI::Application.config.core_url, 'f').to_s
    factlink_pretty_url_re = %r{#{application_url}/(?<id>[0-9]+)}i

    text.gsub(auto_link_re) do |given_url|
      url = if Regexp.last_match[:scheme]
              given_url
            else
              'http://' + given_url
            end

      case url
      when factlink_pretty_url_re
        factlink_link_tag Regexp.last_match[:id]
      else
        content_tag :a, given_url, href: url, target: '_blank'
      end
    end
  end

  def factlink_link_tag fact_id
    begin
      dead_fact = Backend::Facts.get fact_id: fact_id
    rescue
      return content_tag :span, '<deleted annotation>', class: 'formatted-comment-content-factlink'
    end

    fact_url = FactUrl.new(dead_fact)
    proxy_open_url = fact_url.proxy_open_url

    content_tag :a, dead_fact.displaystring, href: proxy_open_url, rel: 'backbone',
      class: 'formatted-comment-content-factlink'
  end
end
