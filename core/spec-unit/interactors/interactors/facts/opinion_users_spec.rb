require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/opinion_users.rb'

describe Interactors::Facts::OpinionUsers do
  include PavlovSupport

  describe '.authorized?' do
    it 'should check if the fact can be shown' do
      stub_classes 'Fact'

      ability = mock
      ability.should_receive(:can?).with(:show, Fact).and_return(false)

      expect do
        interactor = described_class.new 0, 0, 0, 'believes', ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.execute' do
    before do
      stub_classes 'Queries', 'Queries::FactInteractingUsers'
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'correctly' do
      fact_id = 1
      skip = 0
      take = 0
      u1 = mock

      interactor = described_class.new fact_id, skip, take, 'believes'

      interactor.should_receive(:query).
        with(:fact_interacting_users, fact_id, skip, take, 'believes').
        and_return(users: [u1], total: 1)

      results = interactor.execute

      results[:total].should eq 1
      results[:users].should eq [u1]
    end
  end
end
