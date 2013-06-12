require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/get.rb'

describe Interactors::Facts::Get do
  include PavlovSupport

  describe '#validate' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'requires fact_id to be an integer' do
      expect_validating('a', :id).
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      stub_classes 'Fact'

      ability = mock
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      expect do
        interactor = described_class.new '1', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'stores the recently viewed if a user is present' do
      fact = mock(id: '1', evidence_count: nil)
      user = mock(id: '1e')
      evidence_count = 10

      pavlov_options = {current_user: user}

      Pavlov.stub(:query).with(:'facts/get', fact.id, pavlov_options)
        .and_return(fact)
      Pavlov.stub(:query).with(:'evidence/count_for_fact', fact, pavlov_options)
        .and_return(evidence_count)
      fact.stub(:evidence_count=).with(evidence_count)

      Pavlov.should_receive(:command)
        .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s, pavlov_options)

      interactor = described_class.new fact.id, pavlov_options
      interactor.call
    end

    it 'returns the fact and evidence count' do
      fact = mock(id: '1', evidence_count: nil)
      evidence_count = 10

      Pavlov.stub(:query).with(:'facts/get', fact.id)
        .and_return(fact)
      Pavlov.stub(:query).with(:'evidence/count_for_fact', fact)
        .and_return(evidence_count)

      fact.should_receive(:evidence_count=).with(evidence_count)

      interactor = described_class.new fact.id
      expect(interactor.execute).to eq fact
    end
  end
end
