class FormattedCommentContent
  include ActionView::Helpers::TagHelper

  def initialize text
    @text = text
  end

  def html
    urls_to_link_tags ERB::Util.html_escape(@text).to_str
  end

  private

  AUTO_LINK_RE = %r{(?:(?<scheme>http|https)://|www\.)[^\s<\u00A0]+}i
  FACTLINK_PRETTY_URL = %r{#{FactlinkUI::Application.config.core_url}/[a-z0-9\-_]+/f/(?<id>[0-9]+)}i

  def urls_to_link_tags text
    text.gsub(AUTO_LINK_RE) do |href|
      link_text = href
      href = 'http://' + href unless Regexp.last_match[:scheme]

      case href
      when FACTLINK_PRETTY_URL
        factlink_link_tag Regexp.last_match[:id]
      else
        content_tag :a, link_text, href: href, target: '_blank'
      end
    end
  end

  def factlink_link_tag fact_id
    dead_fact = Pavlov.query :'facts/get_dead', id: fact_id
    url = FactUrl.new(dead_fact).friendly_fact_url

    content_tag :a, dead_fact.displaystring, href: url, rel: 'backbone',
      class: 'formatted-comment-content-factlink'
  end
end
