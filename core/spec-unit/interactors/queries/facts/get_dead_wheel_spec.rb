require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_dead_wheel.rb'
require_relative '../../../../app/entities/dead_fact_wheel.rb'

describe Queries::Facts::GetDeadWheel do
  include PavlovSupport

  describe '.validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '.execute' do
    before do
      stub_const('Fact',Class.new)
    end

    it 'returns a fact_wheel representation' do
      opinion = mock :opinion, as_percentages: {
        authority: 14,
        believe: {percentage: 10},
        disbelieve: {percentage: 80},
        doubt: {percentage: 20},
      }
      live_fact = mock :fact, id: '1', get_opinion: opinion
      user = mock :user, graph_user: mock
      interactor = Queries::Facts::GetDeadWheel.new live_fact.id, current_user: user


      user.graph_user.should_receive(:opinion_on)
                     .with(live_fact)
                     .and_return(:believes)
      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact_wheel = interactor.execute

      expect(dead_fact_wheel.authority).
        to eq live_fact.get_opinion.as_percentages[:authority]
      expect(dead_fact_wheel.believe_percentage).
        to eq live_fact.get_opinion.as_percentages[:believe][:percentage]
      expect(dead_fact_wheel.disbelieve_percentage).
        to eq live_fact.get_opinion.as_percentages[:disbelieve][:percentage]
      expect(dead_fact_wheel.doubt_percentage).
        to eq live_fact.get_opinion.as_percentages[:doubt][:percentage]
      expect(dead_fact_wheel.user_opinion).
        to eq :believes
    end

    it 'returns a fact_wheel when there is no current user' do
      opinion = mock :opinion, as_percentages: {
        authority: 14,
        believe: {percentage: 10},
        disbelieve: {percentage: 80},
        doubt: {percentage: 20},
      }
      live_fact = mock :fact, id: '1', get_opinion: opinion
      user = nil
      interactor = Queries::Facts::GetDeadWheel.new live_fact.id, current_user: user

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact_wheel = interactor.execute

      expect(dead_fact_wheel.authority).
        to eq live_fact.get_opinion.as_percentages[:authority]
      expect(dead_fact_wheel.believe_percentage).
        to eq live_fact.get_opinion.as_percentages[:believe][:percentage]
      expect(dead_fact_wheel.disbelieve_percentage).
        to eq live_fact.get_opinion.as_percentages[:disbelieve][:percentage]
      expect(dead_fact_wheel.doubt_percentage).
        to eq live_fact.get_opinion.as_percentages[:doubt][:percentage]
      expect(dead_fact_wheel.user_opinion).
        to eq nil
    end
  end
end
