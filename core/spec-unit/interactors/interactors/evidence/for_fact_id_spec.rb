require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/evidence/for_fact_id.rb'

describe Interactors::Evidence::ForFactId do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe 'validation' do
    it 'requires fact_id to be an integer' do
      expect_validating(fact_id: 'a', type: :disbelieves).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires fact_id not to be nil' do
      expect_validating(fact_id: nil, type: :disbelieves).
        to fail_validation('fact_id should be an integer string.')
    end
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = double
      ability.stub(:can?)
             .with(:show, Fact)
             .and_return(false)

      interactor = described_class.new fact_id: '1',
                                       pavlov_options: { ability: ability }

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'correctly' do
      type = :believes
      fact = double id: '1'
      pavlov_options = { current_user: double, ability: double(can?: true) }
      interactor = described_class.new fact_id: fact.id, type: type,
                                       pavlov_options: pavlov_options

      comment1 = double :comment1, votes: {believes: 2, disbelieves: 1}
      comment2 = double :comment2, votes: {believes: 4, disbelieves: 0}

      type = :disbelieves

      Fact.stub(:[])
          .with(fact.id)
          .and_return(fact)
      Pavlov.stub(:query)
            .with(:'comments/for_fact',
                      fact: fact, pavlov_options: pavlov_options)
            .and_return [comment1, comment2]

      result = interactor.call

      expect(result).to eq [comment2, comment1]
    end
  end
end
