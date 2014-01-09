require 'spec_helper'

describe FormattedCommentContent do
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
      fact = create :fact
      friendly_fact_url = FactUrl.new(fact).friendly_fact_url
      displaystring = fact.data.displaystring

      formatted_comment = described_class.new friendly_fact_url
      expected_html = "<a class=\"formatted-comment-content-factlink\" href=\"http://localhost:3000/fact-1/f/1\" rel=\"backbone\">Fact 1</a>"

      expect(formatted_comment.html).to eq expected_html
    end
  end
end
