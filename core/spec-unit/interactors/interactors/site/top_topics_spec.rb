require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/site/top_topics'

describe Interactors::Site::TopTopics do
  include PavlovSupport

  describe 'validations' do
    it 'requires url to be a string' do
      expect_validating(url: nil, nr: 2).
        to fail_validation('url should be a string.')
    end

    it 'requires the number of items to return' do
      expect_validating(url: 'http://factlink.com', nr: 'a').
        to fail_validation('nr should be an integer.')
    end
  end

  describe '#call' do
    before do
      stub_classes 'Site'
    end

    it 'calls the top_topics query with the site_id' do
      url = 'http://factlink.com'
      nr = 3
      site = mock id: '10'
      results = mock

      Site.should_receive(:find).with(url: url).and_return([site])

      interactor = described_class.new url: url, nr: nr,
        pavlov_options: { current_user: mock }
      interactor.should_receive(:old_query).with(:"site/top_topics", site.id.to_i, nr).and_return results

      expect(interactor.call).to eq results
    end
  end
end
