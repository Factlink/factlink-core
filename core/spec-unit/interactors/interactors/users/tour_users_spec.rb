require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/tour_users'

describe Interactors::Users::TourUsers do
  include PavlovSupport

  before do
    stub_classes 'User', 'KillObject'
  end

  describe '#authorized?' do
    it 'check if User can be indexed' do
      ability = double
      ability.stub(:can?).with(:index, User).and_return(false)

      expect do
        interactor = described_class.new(pavlov_options: { ability: ability })
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#validate' do
    it 'always succeeds' do
      described_class.new(pavlov_options: { ability: double(can?: true) })
    end
  end

  describe '#call' do
    it 'calls the handpicked users query' do
      dead_users = [
        double(:user, graph_user_id: 3),
        double(:user, graph_user_id: 7)
      ]
      user_topics = [double, double]

      dead_users_with_topics = [double, double]

      options = { ability: double(can?: true) }

      interactor = described_class.new(pavlov_options: options)

      Pavlov.stub(:query)
            .with(:'users/handpicked',
                      pavlov_options: options)
            .and_return(dead_users)
      Pavlov.stub(:query)
            .with(:'user_topics/top_with_authority_for_graph_user_id',
                      graph_user_id: dead_users[0].graph_user_id, limit_topics: 2,
                      pavlov_options: options)
            .and_return(user_topics[0])
      Pavlov.stub(:query)
            .with(:'user_topics/top_with_authority_for_graph_user_id',
                      graph_user_id: dead_users[1].graph_user_id, limit_topics: 2,
                      pavlov_options: options)
            .and_return(user_topics[1])

      KillObject.stub(:user)
                .with(dead_users[0], top_user_topics: user_topics[0])
                .and_return(dead_users_with_topics[0])
      KillObject.stub(:user)
                .with(dead_users[1], top_user_topics: user_topics[1])
                .and_return(dead_users_with_topics[1])

      expect(interactor.call).to eq dead_users_with_topics
    end
  end

end
