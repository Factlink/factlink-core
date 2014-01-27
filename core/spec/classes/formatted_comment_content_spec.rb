require 'spec_helper'

describe FormattedCommentContent do
  include ActionView::Helpers::TagHelper

  describe '#html' do
    it 'sanitizes html' do
      formatted_comment = described_class.new '<a>Link</a>'

      expect(formatted_comment.html).to eq '&lt;a&gt;Link&lt;/a&gt;'
    end

    it 'turns url into links' do
      formatted_comment = described_class.new 'http://www.example.org'

      expect(formatted_comment.html).to eq '<a href="http://www.example.org" target="_blank">http://www.example.org</a>'
    end

    it 'works without http' do
      formatted_comment = described_class.new 'www.example.org'

      expect(formatted_comment.html).to eq '<a href="http://www.example.org" target="_blank">www.example.org</a>'
    end

    it 'turns factlink urls into special links (even with port in core_url)' do
      FactlinkUI::Application.config.stub(core_url: 'http://factlink.com:80')

      fact = create :fact
      fact_url = FactUrl.new(fact)
      friendly_fact_url = fact_url.friendly_fact_url
      proxy_open_url = fact_url.proxy_open_url
      displaystring = fact.data.displaystring

      formatted_comment = described_class.new friendly_fact_url
      expected_html = content_tag :a, displaystring, href: proxy_open_url, rel: 'backbone',
        class: 'formatted-comment-content-factlink'

      expect(formatted_comment.html).to eq expected_html
    end
  end
end
