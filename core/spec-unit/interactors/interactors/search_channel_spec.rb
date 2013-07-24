require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/search_channel.rb'

describe Interactors::SearchChannel do
  include PavlovSupport

  let(:relaxed_ability) { stub(:ability, can?: true)}

  before do
    stub_classes 'Topic','Queries::ElasticSearchChannel',
                 'Fact','Ability::FactlinkWebapp'
  end

  describe 'validation' do
    it 'requires keywords to be a nonempty string' do
      interactor = described_class.new keywords: nil
      expect { interactor.call }
        .to fail_validation 'keywords should be a nonempty string.'
    end
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      keywords = "searching for this channel"
      ability = stub(:ability, can?: false)

      interactor = described_class.new keywords: keywords,
          pavlov_options: { ability: ability }

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.call' do
    it 'correctly' do
      keywords = 'searching for this channel'
      interactor = described_class.new keywords: keywords,
        pavlov_options: { ability: relaxed_ability }
      topic = mock()
      query = mock()
      query.should_receive(:call).
        and_return([topic])
      Queries::ElasticSearchChannel.should_receive(:new).
        with(keywords, 1, 20, ability: relaxed_ability).
        and_return(query)

      interactor.call.should eq [topic]
    end
  end
end
