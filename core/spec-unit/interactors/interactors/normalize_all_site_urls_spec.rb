require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/normalize_all_site_urls.rb'

describe Interactors::NormalizeAllSiteUrls do
  include PavlovSupport

  before do
    stub_classes 'Site', 'Resque', 'Interactors::NormalizeSiteUrl'
  end

  describe '#call' do
    it 'should push a task to resque for every site' do
      ids = [1, 2]
      Site.stub(all: double(ids: ids))

      Resque.should_receive(:enqueue).with(Interactors::NormalizeSiteUrl,
        site_id: 1, normalizer_class_name: :UrlNormalizer)
      Resque.should_receive(:enqueue).with(Interactors::NormalizeSiteUrl,
        site_id: 2, normalizer_class_name: :UrlNormalizer)

      subject.call
    end
  end
end
