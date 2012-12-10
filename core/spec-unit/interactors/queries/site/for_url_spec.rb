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

  describe '.execute' do

    before do
      stub_classes 'Site'
    end

    it 'return the Site corresponding to the normalized url' do
      url = 'http://jsdares.com'
      query = Queries::Site::ForUrl.new url

      site = mock
      Site.should_receive(:find).with(url: url).and_return([site])

      expect(query.execute).to eq site
    end

  end
end
