require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/get.rb'

describe Interactors::Facts::Get do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe 'validation' do
    it 'requires id to be a integer string' do
      expect_validating( id: 'a' )
        .to fail_validation('id should be an integer string.')
    end
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = stub(:can?)
        .with(:show, Fact)
        .and_return(false)

      interactor = described_class.new id: '1',
        pavlov_options: { abillity: ability }

      expect( interactor.call )
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'stores the recently viewed if a user is present' do
      fact = mock(id: '1', evidence_count: nil)
      user = mock(id: '1e')
      evidence_count = 10

      pavlov_options = { current_user: user, ability: mock(can?: true) }

      Pavlov.stub(:old_query).with(:'facts/get', fact.id, pavlov_options)
        .and_return(fact)

      Pavlov.should_receive(:old_command)
        .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s,
          pavlov_options)

      interactor = described_class.new id: fact.id,
        pavlov_options: pavlov_options
      interactor.call
    end

    it 'returns the fact' do
      fact = mock(id: '1', evidence_count: nil)
      evidence_count = 10

      pavlov_options = { ability: mock(can?: true) }

      Pavlov.stub(:old_query).with(:'facts/get', fact.id, pavlov_options)
        .and_return(fact)

      interactor = described_class.new id: fact.id,
        pavlov_options: pavlov_options
      expect(interactor.call).to eq fact
    end
  end
end
