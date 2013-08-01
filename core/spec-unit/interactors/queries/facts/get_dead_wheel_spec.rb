require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_dead_wheel.rb'
require_relative '../../../../app/entities/dead_fact_wheel.rb'

describe Queries::Facts::GetDeadWheel do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'OpinionPresenter'
  end

  describe 'validation' do
    it 'requires fact_id to be an integer' do
      expect_validating(id: 'a').
        to fail_validation('id should be an integer string.')
    end
  end

  describe '#call' do
    it 'returns a fact_wheel representation' do
      percentage_hash = {
        authority: 14,
        believe: {percentage: 10},
        disbelieve: {percentage: 80},
        doubt: {percentage: 20},
      }
      presenter = mock as_percentages_hash: percentage_hash
      opinion = mock :opinion
      live_fact = mock :fact, id: '1'
      user = mock :user, graph_user: mock
      pavlov_options = {current_user: user}
      interactor = described_class.new id: live_fact.id,
        pavlov_options: pavlov_options

      OpinionPresenter.stub(:new).with(opinion)
                      .and_return(presenter)
      Pavlov.stub(:old_query)
            .with(:'opinions/opinion_for_fact', live_fact, pavlov_options)
            .and_return(opinion)
      user.graph_user.stub(:opinion_on)
                     .with(live_fact)
                     .and_return(:believes)
      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact_wheel = interactor.call

      expect(dead_fact_wheel.authority).
        to eq percentage_hash[:authority]
      expect(dead_fact_wheel.believe_percentage).
        to eq percentage_hash[:believe][:percentage]
      expect(dead_fact_wheel.disbelieve_percentage).
        to eq percentage_hash[:disbelieve][:percentage]
      expect(dead_fact_wheel.doubt_percentage).
        to eq percentage_hash[:doubt][:percentage]
      expect(dead_fact_wheel.user_opinion).
        to eq :believes
    end

    it 'returns a fact_wheel when there is no current user' do
      percentage_hash = {
        authority: 14,
        believe: {percentage: 10},
        disbelieve: {percentage: 80},
        doubt: {percentage: 20},
      }
      presenter = mock as_percentages_hash: percentage_hash
      opinion = mock :opinion
      OpinionPresenter.stub(:new).with(opinion)
                      .and_return(presenter)

      live_fact = mock :fact, id: '1'
      user = nil
      pavlov_options = {current_user: user}

      query = described_class.new id: live_fact.id,
        pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
            .with(:'opinions/opinion_for_fact', live_fact, pavlov_options)
            .and_return(opinion)
      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      dead_fact_wheel = query.call

      expect(dead_fact_wheel.authority).
        to eq percentage_hash[:authority]
      expect(dead_fact_wheel.believe_percentage).
        to eq percentage_hash[:believe][:percentage]
      expect(dead_fact_wheel.disbelieve_percentage).
        to eq percentage_hash[:disbelieve][:percentage]
      expect(dead_fact_wheel.doubt_percentage).
        to eq percentage_hash[:doubt][:percentage]
      expect(dead_fact_wheel.user_opinion).
        to eq nil
    end
  end
end
