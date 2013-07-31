require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/get.rb'

describe Interactors::Facts::Get do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '.validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = mock
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      expect do
        interactor = described_class.new '1', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'stores the recently viewed if a user is present' do
      fact = mock(id: '1', evidence_count: nil)
      user = mock(id: '1e')
      evidence_count = 10

      pavlov_options = {current_user: user, ability: mock(can?: true)}

      Pavlov.stub(:old_query).with(:'facts/get', fact.id, pavlov_options)
        .and_return(fact)

      Pavlov.should_receive(:old_command)
        .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s, pavlov_options)

      interactor = described_class.new fact.id, pavlov_options
      interactor.call
    end

    it 'returns the fact' do
      fact = mock(id: '1', evidence_count: nil)
      evidence_count = 10

      pavlov_options = { ability: mock(can?: true)}

      Pavlov.stub(:old_query).with(:'facts/get', fact.id, pavlov_options)
        .and_return(fact)

      interactor = described_class.new fact.id, pavlov_options
      expect(interactor.call).to eq fact
    end
  end
end
