require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/site/for_url'

describe Queries::Site::ForUrl do
  include PavlovSupport

  describe 'validations' do
    let(:subject_class) { Queries::Site::ForUrl }

    it 'requires arguments' do
      expect_validating(nil).
        to fail_validation('url should be a string.')
    end
  end

  describe '.site' do

    before do
      stub_classes 'Site'
    end

    it 'return the Site corresponding to the normalized url' do
      url = 'http://jsdares.com'
      query = Queries::Site::ForUrl.new url

      site = mock
      Site.should_receive(:find).with(url: url).and_return([site])

      expect(query.site).to eq site
    end
  end

  describe '.execute' do

    before do
      stub_classes 'KillObject'
    end

    it 'returns nil if site is nil' do
      url = 'http://jsdares.com'
      query = Queries::Site::ForUrl.new url

      query.should_receive(:site).and_return(nil)

      expect(query.execute).to eq nil
    end

    it 'returns a dead site' do
      url = 'http://jsdares.com'
      query = Queries::Site::ForUrl.new url

      site = mock
      dead_site = mock

      query.should_receive(:site).any_number_of_times.and_return(site)
      KillObject.should_receive(:site).with(site).and_return(dead_site)

      expect(query.execute).to eq dead_site
    end
  end

end

