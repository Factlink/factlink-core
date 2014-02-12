require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/votes.rb'

describe Interactors::Facts::Votes do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = double
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      interactor = described_class.new(fact_id: '0', pavlov_options: { ability: ability } )

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'requires fact_id to be a integer string' do
      expect_validating( fact_id: 'a')
        .to fail_validation('fact_id should be an integer string.')
    end
  end

  describe '#call' do
    it 'correctly' do
      fact = double id: "1"
      u1, u2, u3 = double, double, double

      pavlov_options = { ability: double(can?: true)}

      Pavlov.stub(:query)
            .with(:'facts/get',
                      id: fact.id.to_s,
                      pavlov_options: pavlov_options)
            .and_return(fact)

      Pavlov.stub(:query)
            .with(:'facts/opinionators',
                      fact: fact, type: 'believes',
                      pavlov_options: pavlov_options)
            .and_return([u1])
      Pavlov.stub(:query)
            .with(:'facts/opinionators',
                      fact: fact, type: 'disbelieves',
                      pavlov_options: pavlov_options)
            .and_return([u2])
      Pavlov.stub(:query)
            .with(:'facts/opinionators',
                      fact: fact, type: 'doubts',
                      pavlov_options: pavlov_options)
            .and_return([u3])

      interactor = described_class.new fact_id: fact.id, pavlov_options: pavlov_options
      results = interactor.call

      expect(results).to eq [
        {
          user: u1,
          type: 'believes'
        },
        {
          user: u2,
          type: 'disbelieves'
        },
        {
          user: u3,
          type: 'doubts'
        }
      ]

    end
  end
end
