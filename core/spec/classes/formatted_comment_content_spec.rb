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

    it 'turns factlink urls into special links' do
      FactlinkUI::Application.config.stub(core_url: 'http://factlink.com')

      fact_data = create :fact_data
      dead_fact = Backend::Facts.get(fact_id: fact_data.fact_id)
      fact_url = FactUrl.new(dead_fact)
      friendly_fact_url = fact_url.friendly_fact_url
      proxy_open_url = fact_url.proxy_open_url
      displaystring = dead_fact.displaystring

      formatted_comment = described_class.new friendly_fact_url
      expected_html = content_tag :a, displaystring, href: proxy_open_url, rel: 'backbone',
        class: 'formatted-comment-content-factlink'

      expect(formatted_comment.html).to eq expected_html
    end

    it 'turns factlink urls that have been deleted into <deleted annotation>' do
      FactlinkUI::Application.config.stub(core_url: 'http://factlink.com')

      fact_data = create :fact_data
      dead_fact = Backend::Facts.get(fact_id: fact_data.fact_id)
      fact_url = FactUrl.new(dead_fact)
      friendly_fact_url = fact_url.friendly_fact_url

      fact_data.destroy

      formatted_comment = described_class.new friendly_fact_url
      expected_html = content_tag :span, '<deleted annotation>',
        class: 'formatted-comment-content-factlink'

      expect(formatted_comment.html).to eq expected_html
    end
  end
end
