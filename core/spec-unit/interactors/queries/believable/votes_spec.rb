require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/believable/votes.rb'

describe Queries::Believable::Votes do
  include PavlovSupport

  describe '#call' do
    it 'returns votes and current_user_opinion' do
      opinion = :believes
      believable = double votes: {believes_count: 1}
      user = double :user, graph_user: double
      pavlov_options = {current_user: user}
      interactor = described_class.new believable: believable,
        pavlov_options: pavlov_options

      believable.stub(:opinion_of_graph_user).with(user.graph_user).and_return(opinion)

      votes = interactor.call

      expect(votes[:believes_count]).to eq 1
      expect(votes[:current_user_opinion]).to eq :believes
    end

    it 'current_user_opinion :no_vote when no user is given' do
      believable = double votes: {believes_count: 1}
      user = nil
      pavlov_options = {current_user: user}
      query = described_class.new believable: believable,
        pavlov_options: pavlov_options

      votes = query.call

      expect(votes[:believes_count]).to eq 1
      expect(votes[:current_user_opinion]).to eq :no_vote
    end
  end
end
