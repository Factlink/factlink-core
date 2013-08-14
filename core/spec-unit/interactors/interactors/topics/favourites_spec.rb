require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/favourites'

describe Interactors::Topics::Favourites do
  include PavlovSupport

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect { described_class.new(user_name: 'foo').call }
        .to raise_error(Pavlov::AccessDenied,'Unauthorized')
    end

    it 'throws when cannot show favourites' do
      user = double
      current_user = double

      ability = double
      ability.stub(:can?).with(:show_favourites, user).and_return(false)
      pavlov_options = { current_user: current_user, ability: ability }
      interactor = described_class.new(user_name: 'username',
        pavlov_options: pavlov_options)

      Pavlov.stub(:query)
        .with(:user_by_username, username: 'username', pavlov_options: pavlov_options)
        .and_return(user)

      expect do
        interactor.call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'validations' do
    it 'without valid user_name doesn\'t validate' do
      expect_validating(user_name: '')
        .to fail_validation('user_name should be a nonempty string.')
    end
  end

  describe '#call' do
    it 'it calls the query to get an alphabetically list of followed users' do
      user_name = 'henkie'
      current_user = double
      pavlov_options = {current_user: current_user, ability: double(can?: true)}
      interactor = described_class.new user_name: user_name, pavlov_options: pavlov_options

      user = double(graph_user_id: double)
      topic1 = double(id: double, slug_title: 'b')
      topic2 = double(id: double, slug_title: 'a')

      Pavlov.stub(:query)
        .with(:'user_by_username', username: user_name, pavlov_options: pavlov_options)
        .and_return(user)
      Pavlov.stub(:query)
        .with(:'topics/favourite_topic_ids', graph_user_id: user.graph_user_id, pavlov_options: pavlov_options)
        .and_return([topic1.id, topic2.id])
      Pavlov.stub(:query)
        .with(:'topics/by_id', id: topic1.id, pavlov_options: pavlov_options)
        .and_return(topic1)
      Pavlov.stub(:query)
        .with(:'topics/by_id', id: topic2.id, pavlov_options: pavlov_options)
        .and_return(topic2)

      expect(interactor.call).to eq [topic2, topic1]
    end
  end
end
