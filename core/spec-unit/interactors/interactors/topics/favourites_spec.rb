require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/favourites'

describe Interactors::Topics::Favourites do
  include PavlovSupport

  describe '.new' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'returns an object' do
      interactor = described_class.new mock, mock

      expect(interactor).to_not be_nil
    end
  end

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect { described_class.new mock, {} }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when cannot show favourites' do
      user = double
      current_user = double

      ability = double
      ability.stub(:can?).with(:show_favourites, user).and_return(false)

      pavlov_options = { current_user: current_user, ability: ability }

      described_class.any_instance.stub(:old_query).
        with(:user_by_username, 'username').
        and_return(user)

      expect { described_class.new 'username', pavlov_options }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end

    it 'does not throw if current_user is set and favourites can be shown' do
      user = double
      current_user = double

      ability = double
      ability.stub(:can?).with(:show_favourites, user).and_return(true)

      pavlov_options = { current_user: current_user, ability: ability }

      described_class.any_instance.stub(:old_query).
        with(:user_by_username, 'username').
        and_return(user)

      described_class.new 'username', pavlov_options
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      user_name = double

      described_class.any_instance.should_receive(:validate_nonempty_string).
        with(:user_name, user_name)

      interactor = described_class.new user_name
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'it calls the query to get an alphabetically list of followed users' do
      user_name = double
      current_user = double
      interactor = described_class.new user_name, current_user: current_user

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

      result = interactor.execute

      expect(result).to eq [topic2, topic1]
    end
  end
end
