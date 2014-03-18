require 'pavlov_helper'
require_relative '../../../app/interactors/backend/sites.rb'

describe Backend::Sites do
  include PavlovSupport

  before do
    stub_classes 'Site', 'Resque', 'NormalizeSiteUrl'
  end

  describe '.normalize_all_urls' do
    it 'should push a task to resque for every site' do
      allow(Site).to receive(:all)
        .and_return(double(ids: [1, 2]))

      expect(Resque).to receive(:enqueue)
        .with(NormalizeSiteUrl, site_id: 1)
      expect(Resque).to receive(:enqueue)
        .with(NormalizeSiteUrl, site_id: 2)

      Backend::Sites.normalize_all_urls
    end
  end
end
