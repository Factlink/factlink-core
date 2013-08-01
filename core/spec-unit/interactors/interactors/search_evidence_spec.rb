require 'pavlov_helper'
require_relative '../../../app/interactors/util/search'
require_relative '../../../app/interactors/interactors/search_evidence.rb'

describe Interactors::SearchEvidence do
  include PavlovSupport

  let(:relaxed_ability) { double(:ability, can?: true)}

  before do
    stub_classes 'Fact', 'FactData', 'Ability::FactlinkWebapp',
                 'Queries::ElasticSearchFactData'
  end

  it 'initializes' do
    interactor = described_class.new keywords: 'zoeken interessante dingen',
      fact_id: '1', pavlov_options: { ability: relaxed_ability }
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    interactor = described_class.new keywords: nil, fact_id: '1'
    expect { interactor.call }.
      to raise_error(RuntimeError,'Keywords should be an string.')
  end

  it 'raises when initialized with a fact_id that is not a string' do
    interactor = described_class.new keywords: 'key words', fact_id: nil
    expect { interactor.call }.
      to raise_error(RuntimeError, 'Fact_id should be an number.')
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      ability = double(:ability, can?: false)

      interactor = described_class.new keywords: 'zoeken interessante dingen',
          fact_id: '1', pavlov_options: { ability: ability }
      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'returns a empty array when the keyword string is empty' do
      keywords = 'zoeken interessante dingen'
      interactor = described_class.new keywords: '', fact_id: '1',
        pavlov_options: { ability: relaxed_ability }

      expect( interactor.call ).to eq []
    end

    it 'shouldn\'t return itself' do
      keywords = 'zoeken interessante dingen'
      interactor = described_class.new keywords: keywords, fact_id: '2',
        pavlov_options: { ability: relaxed_ability }

      result = [get_fact_data('2')]

      Pavlov.should_receive(:old_query)
        .with(:elastic_search_fact_data, keywords, 1, 20, ability: relaxed_ability)
        .and_return(result)

      FactData.stub :valid => true

      expect( interactor.call ).to eq []
    end

    it 'correctly' do
      keywords = 'zoeken interessante dingen'
      interactor = described_class.new keywords: keywords, fact_id: '1',
        pavlov_options: { ability: relaxed_ability }

      result = [get_fact_data('2')]

      Pavlov.should_receive(:old_query)
        .with(:elastic_search_fact_data, keywords, 1, 20, ability: relaxed_ability)
        .and_return(result)

      FactData.stub :valid => true

      expect( interactor.call ).to eq result
    end

    it 'shouldn\'t return invalid results' do
      keywords = 'zoeken interessante dingen'
      interactor = described_class.new keywords: keywords, fact_id: '1',
        pavlov_options: { ability: relaxed_ability }
      fact_data = get_fact_data '2'
      fact_data2 = get_fact_data '3'

      result = [fact_data, fact_data2]

      Pavlov.should_receive(:old_query)
        .with(:elastic_search_fact_data, 'zoeken interessante dingen', 1, 20, ability: relaxed_ability)
        .and_return(result)

      FactData.should_receive(:valid).with(fact_data).and_return(false)
      FactData.should_receive(:valid).with(fact_data2).and_return(true)

      interactor.call.should eq [fact_data2]
    end
  end

  private
  def get_fact_data id
    fact = double
    fact.stub :id => id
    fact_data = double
    fact_data.stub :fact => fact

    fact_data
  end
end
