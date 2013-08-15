require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/search_channel.rb'

describe Interactors::SearchChannel do
  include PavlovSupport

  let(:relaxed_ability) { double(:ability, can?: true)}

  before do
    stub_classes 'Topic','Queries::ElasticSearchChannel',
                 'Fact','Ability::FactlinkWebapp'
  end

  describe 'validations' do
    it 'requires keywords to be a nonempty string' do
      interactor = described_class.new keywords: nil
      expect { interactor.call }
        .to fail_validation 'keywords should be a nonempty string.'
    end
  end

  describe '#authorized?' do
    it 'raises when executed without any permission' do
      keywords = "searching for this channel"
      ability = double(:ability, can?: false)

      interactor = described_class.new keywords: keywords,
          pavlov_options: { ability: ability }

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'correctly' do
      keywords = 'searching for this channel'
      interactor = described_class.new keywords: keywords,
        pavlov_options: { ability: relaxed_ability }
      topic = double
      Pavlov.should_receive(:query)
            .with(:'elastic_search_channel',
                      keywords: keywords, page: 1, row_count: 20,
                      pavlov_options: { ability: relaxed_ability })
            .and_return([topic])

      interactor.call.should eq [topic]
    end
  end
end
