require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/site/for_url'

describe Queries::Sites::ForUrl do
  include PavlovSupport

  describe 'validations' do
    let(:subject_class) { Queries::Sites::ForUrl }

    it 'requires arguments' do
      expect_validating(nil).
        to fail_validation('url should be a string.')
    end
  end

  describe '.call' do
    before do
      stub_classes 'Site'
    end

    it 'returns nil if site is nil' do
      url = 'http://jsdares.com'
      query = Queries::Sites::ForUrl.new url

      Site.should_receive(:find).with(url: url).and_return([])

      expect(query.call).to eq nil
    end

    it 'returns a site' do
      url = 'http://jsdares.com'
      query = Queries::Sites::ForUrl.new url

      site = mock
      dead_site = mock

      Site.should_receive(:find).with(url: url).and_return([site])

      expect(query.call).to eq site
    end
  end

end

