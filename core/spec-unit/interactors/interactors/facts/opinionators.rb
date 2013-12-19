require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/opinion_users.rb'

describe Interactors::Facts::Opinionators
 do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = double
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      interactor = described_class.new(fact_id: 0,
                                       type: 'believes', pavlov_options: { ability: ability } )

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'requires fact_id to be a integer string' do
      expect_validating( fact_id: 'a', type: 'disbelieves' )
        .to fail_validation('fact_id should be an integer.')
    end

    it 'it throws when initialized with a unknown opinion type' do
      expect_validating( fact_id: 1, type: 'W00T')
        .to fail_validation 'type should be on of these values: ["believes", "disbelieves", "doubts"].'
    end
  end

  describe '#call' do
    it 'correctly' do
      fact_id = 1
      u1 = double
      type = 'believes'

      pavlov_options = { ability: double(can?: true)}

      Pavlov.stub(:query)
            .with(:'facts/opinionators',
                      fact_id: fact_id, opinion: type,
                      pavlov_options: pavlov_options)
            .and_return(users: [u1], total: 1)

      interactor = described_class.new fact_id: fact_id,
                                       type: type, pavlov_options: pavlov_options
      results = interactor.call

      expect(results[:total]).to eq 1
      expect(results[:users]).to eq [u1]
      expect(results[:type]).to eq type
    end
  end
end
