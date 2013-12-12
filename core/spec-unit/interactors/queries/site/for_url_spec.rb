require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sites/for_url'

describe Queries::Sites::ForUrl do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Site'
    end

    it 'returns nil if site is nil' do
      url = 'http://jsdares.com'
      query = described_class.new url: url

      Site.should_receive(:find).with(url: url).and_return([])

      expect(query.call).to eq nil
    end

    it 'returns a site' do
      url = 'http://jsdares.com'
      query = described_class.new url: url
      site = double
      dead_site = double

      Site.should_receive(:find).with(url: url).and_return([site])

      expect(query.call).to eq site
    end
  end
end
