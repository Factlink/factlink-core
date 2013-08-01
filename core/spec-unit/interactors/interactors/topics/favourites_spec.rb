require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/favourites'

describe Interactors::Topics::Favourites do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect { described_class.new(user_name: mock).call }
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

      Pavlov.stub(:old_query)
        .with(:user_by_username, 'username', pavlov_options)
        .and_return(user)

      expect { interactor.call }
        .to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'validations' do
    it 'without valid user_name doesn\'t validate' do
      expect_validating(user_name: '')
        .to fail_validation('user_name should be a nonempty string.')
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'it calls the query to get an alphabetically list of followed users' do
      user_name = double
      current_user = double
      interactor = described_class.new user_name: user_name

      user = mock(graph_user_id: mock)
      topic1 = mock(id: mock, slug_title: 'b')
      topic2 = mock(id: mock, slug_title: 'a')

      Pavlov.should_receive(:old_query)
        .with(:'user_by_username', user_name)
        .and_return(user)
      Pavlov.should_receive(:old_query)
        .with(:'topics/favourite_topic_ids', user.graph_user_id)
        .and_return([topic1.id, topic2.id])
      Pavlov.should_receive(:old_query)
        .with(:'topics/by_id', topic1.id)
        .and_return(topic1)
      Pavlov.should_receive(:old_query)
        .with(:'topics/by_id', topic2.id)
        .and_return(topic2)

      expect(interactor.call).to eq [topic2, topic1]
    end
  end
end
