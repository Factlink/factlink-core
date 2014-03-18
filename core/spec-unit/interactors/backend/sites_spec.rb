require 'pavlov_helper'
require_relative '../../../app/interactors/backend/sites.rb'

describe Backend::Sites do
  include PavlovSupport

  before do
    stub_classes 'Site', 'Resque', 'NormalizeSiteUrl'
  end

  describe '.normalize_all_urls' do
    it 'should push a task to resque for every site' do
      ids = [1, 2]
      Site.stub(all: double(ids: ids))

      Resque.should_receive(:enqueue).with(NormalizeSiteUrl,
        site_id: 1, normalizer_class_name: :UrlNormalizer)
      Resque.should_receive(:enqueue).with(NormalizeSiteUrl,
        site_id: 2, normalizer_class_name: :UrlNormalizer)

      Backend::Sites.normalize_all_urls
    end
  end
end
