class FormattedCommentContent
  include ActionView::Helpers::TagHelper

  def initialize text
    @text = text
  end

  def html
    urls_to_links ERB::Util.html_escape(@text).to_str
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
end
