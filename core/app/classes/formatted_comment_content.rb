class FormattedCommentContent
  include ActionView::Helpers::TagHelper

  def initialize text
    @text = text
  end

  def html
    displaystring_in_factlinks urls_to_links ERB::Util.html_escape(@text).to_str
  end

  private

  AUTO_LINK_RE = %r{(?:(http|https)://|www\.)[^\s<\u00A0]+}i
  def urls_to_links text
    text.gsub(AUTO_LINK_RE) do |href|
      scheme = Regexp.last_match[1]

      link_text = href
      href = 'http://' + href unless scheme

      content_tag(:a, link_text, href: href, target: '_blank')
    end
  end

  FACTLINKS_IN_A_TAGS = %r{>#{FactlinkUI::Application.config.core_url}/[a-z0-9\-_]+/f/([0-9]+)</a>}i
  def displaystring_in_factlinks text
    text.gsub(FACTLINKS_IN_A_TAGS) do |href|
      fact_id = Regexp.last_match[1]
      dead_fact = Pavlov.query :'facts/get_dead', id: fact_id

      ' class="formatted-comment-content-factlink">' + dead_fact.displaystring + '</a>'
    end
  end
end
