require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/opinion_users.rb'

describe Interactors::Facts::OpinionUsers do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#authorized?' do
    it 'should check if the fact can be shown' do
      ability = mock
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      expect do
        interactor = described_class.new 0, 0, 0, 'believes', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'it throws when initialized without a correct fact_id' do
      expect { described_class.new 'a', 0, 3, 'disbelieves'}.
        to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
    end

    it 'it throws when initialized with a skip argument that is not an integer.' do
      expect { described_class.new 1, 'a', 3, 'doubts'}.
        to raise_error(Pavlov::ValidationError, 'skip should be an integer.')
    end

    it 'it throws when initialized with a take argument that is not an integer.' do
      expect { described_class.new 1, 0, 'b', 'doubts'}.
        to raise_error(Pavlov::ValidationError, 'take should be an integer.')
    end

    it 'it throws when initialized with a unknown opinion type' do
      expect { described_class.new 1, 0, 3, 'W00T'}.
        to raise_error(Pavlov::ValidationError, 'type should be on of these values: ["believes", "disbelieves", "doubts"].')
    end
  end

  describe '#call' do
    it 'correctly' do
      fact_id = 1
      skip = 0
      take = 0
      u1 = mock
      impact = mock
      type = 'believes'

      pavlov_options = { ability: mock(can?: true)}

      Pavlov.stub(:query)
        .with(:'facts/interacting_users', fact_id, skip, take, type, pavlov_options)
        .and_return(users: [u1], total: 1)
      Pavlov.stub(:query)
        .with(:'facts/interacting_users_impact', fact_id, type, pavlov_options)
        .and_return(impact)

      interactor = described_class.new fact_id, skip, take, type, pavlov_options
      results = interactor.call

      expect(results[:total]).to eq 1
      expect(results[:users]).to eq [u1]
      expect(results[:impact]).to eq impact
      expect(results[:type]).to eq type
    end
  end
end
