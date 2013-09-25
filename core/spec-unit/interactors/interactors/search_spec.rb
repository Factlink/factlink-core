require 'pavlov_helper'
require_relative '../../../app/interactors/util/search'
require_relative '../../../app/interactors/interactors/search.rb'

describe Interactors::Search do
  include PavlovSupport

  let(:relaxed_ability) { double(:ability, can?: true)}

  before do
    stub_classes 'Fact', 'Queries::ElasticSearchAll', 'FactData',
                 'User', 'Ability::FactlinkWebapp', 'Topic'
  end

  it 'raises when initialized with keywords that is not a string' do
    interactor = described_class.new keywords: nil, page: '1', row_count: 20
    expect { interactor.call }
      .to raise_error(RuntimeError, 'Keywords should be an string.')
  end

  it 'raises when initialized with an empty keywords string' do
    interactor = described_class.new keywords: '', page: '1', row_count: 20
    expect { interactor.call }
      .to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '#call' do
    it 'raises when called without any permission' do
      ability = double(:ability, can?: false)
      interactor = described_class.new keywords: 'keywords', page: 1,
        row_count: 20, pavlov_options: { ability: ability }

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '#call' do
    it 'correctly' do
      keywords = "searching for this channel"
      interactor = described_class.new keywords: keywords, page: 1, row_count: 20,
        pavlov_options: { ability: relaxed_ability }
      results = ['a','b','c']

      Pavlov.should_receive(:query)
            .with(:'elastic_search_all',
                      keywords: keywords, page: 1, row_count: 20,
                      pavlov_options: { ability: relaxed_ability })
            .and_return(results)

      interactor.call.should eq results
    end

    it 'invalid Factdata is filtered' do
      keywords = 'searching for this channel'
      interactor = described_class.new keywords: keywords, page: 1, row_count: 20,
        pavlov_options: { ability: relaxed_ability }
      fact_data = FactData.new
      results =  [fact_data]

      Pavlov.should_receive(:query)
            .with(:'elastic_search_all',
                      keywords: keywords, page: 1, row_count: 20,
                      pavlov_options: { ability: relaxed_ability })
            .and_return(results)
      FactData.stub invalid: true

      interactor.call.should eq []
    end

    it 'hidden User is filtered' do
      keywords = 'searching for this channel'
      interactor = described_class.new keywords: keywords, page: 1, row_count: 20,
        pavlov_options: { ability: relaxed_ability }
      user = User.new
      user.stub hidden?: true
      results = [user]

      Pavlov.should_receive(:query)
            .with(:'elastic_search_all', keywords: keywords, page: 1,
                      row_count: 20, pavlov_options: { ability: relaxed_ability })
            .and_return(results)

      interactor.call.should eq []
    end
  end
end
