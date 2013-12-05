require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/facts/get_votes.rb'

describe Queries::Facts::GetVotes do
  include PavlovSupport

  before do
    stub_classes 'Fact'
  end

  describe '#call' do
    it 'returns a fact_wheel representation' do
      opinion = :believes
      believable = double votes: {believes_count: 1}
      live_fact = double :fact, id: '1', believable: believable
      user = double :user, graph_user: double
      pavlov_options = {current_user: user}
      interactor = described_class.new id: live_fact.id,
        pavlov_options: pavlov_options

      believable.stub(:opinion_of_graph_user).with(user.graph_user).and_return(opinion)

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      votes = interactor.call

      expect(votes[:believes_count]).to eq 1
      expect(votes[:current_user_opinion]).to eq :believes
    end

    it 'returns a fact_wheel when there is no current user' do
      believable = double votes: {believes_count: 1}
      live_fact = double id: '1', believable: believable
      user = nil
      pavlov_options = {current_user: user}
      query = described_class.new id: live_fact.id,
        pavlov_options: pavlov_options

      Fact.stub(:[]).with(live_fact.id).and_return(live_fact)

      votes = query.call

      expect(votes[:believes_count]).to eq 1
      expect(votes[:current_user_opinion]).to eq nil
    end
  end
end
