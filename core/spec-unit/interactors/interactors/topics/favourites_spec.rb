require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/favourites'

describe Interactors::Topics::Favourites do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect { described_class.new(mock).call }
        .to raise_error(Pavlov::AccessDenied,'Unauthorized')
    end

    it 'throws when cannot show favourites' do
      user = stub
      current_user = stub
      ability = stub
      ability.stub(:can?).with(:show_favourites, user).and_return(false)
      pavlov_options = { current_user: current_user, ability: ability }

      Pavlov.stub(:old_query)
        .with(:user_by_username, 'username', pavlov_options)
        .and_return(user)

      expect { described_class.new('username', pavlov_options) }
        .to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe 'validations' do
    it 'without valid user_name doesn\'t validate' do
      expect_validating(1)
        .to fail_validation('user_name should be a nonempty string.')
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'it calls the query to get an alphabetically list of followed users' do
      user_name = mock
      current_user = mock
      interactor = described_class.new(user_name, current_user )

      user = mock(graph_user_id: mock)
      topic1 = mock(id: mock, slug_title: 'b')
      topic2 = mock(id: mock, slug_title: 'a')

      interactor.should_receive(:old_query).
        with(:'user_by_username', user_name).
        and_return(user)
      interactor.should_receive(:old_query).
        with(:'topics/favourite_topic_ids', user.graph_user_id).
        and_return([topic1.id, topic2.id])
      interactor.should_receive(:old_query).
        with(:'topics/by_id', topic1.id).
        and_return(topic1)
      interactor.should_receive(:old_query).
        with(:'topics/by_id', topic2.id).
        and_return(topic2)

      expect(interactor.call).to eq [topic2, topic1]
    end
  end
end
