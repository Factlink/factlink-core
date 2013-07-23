require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/favourite'

describe Interactors::Topics::Favourite do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance
        .should_receive(:validate)
        .and_return(true)
    end

    it 'throws when no current_user' do
      expect { described_class.new mock, mock, {} }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when cannot edit favourites' do
      user = stub
      current_user = stub

      ability = stub
      ability.stub(:can?).with(:edit_favourites, user).and_return(false)

      pavlov_options = { current_user: current_user, ability: ability }

      described_class.any_instance.stub(:query).
        with(:user_by_username, 'username').
        and_return(user)

      expect { described_class.new 'username', 'slug_title', pavlov_options }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end

    it 'does not throw if current_user is set and favourites can be edited' do
      user = stub
      current_user = stub

      ability = stub
      ability.stub(:can?).with(:edit_favourites, user).and_return(true)

      pavlov_options = { current_user: current_user, ability: ability }

      described_class.any_instance.stub(:query).
        with(:user_by_username, 'username').
        and_return(user)

      described_class.new 'username', 'slug_title', pavlov_options
    end
  end

  describe '.new' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'returns an object' do
      interactor = described_class.new mock, mock

      expect(interactor).to_not be_nil
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to favourite topic' do
      user_name = mock
      slug_title = mock
      interactor = described_class.new user_name, slug_title
      user = mock(graph_user_id: mock)
      topic = mock(id: mock)

      interactor.stub(:query)
        .with(:'user_by_username', user_name)
        .and_return(user)
      interactor.stub(:query)
        .with(:'topics/by_slug_title', slug_title)
        .and_return(topic)
      interactor.should_receive(:old_command)
        .with(:'topics/favourite', user.graph_user_id, topic.id.to_s)
      interactor.should_receive(:mp_track)
        .with('Topic: Favourited', slug_title: slug_title)

      result = interactor.execute

      expect(result).to eq nil
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance.stub(authorized?: true)
    end

    it 'calls the correct validation methods' do
      user_name = mock
      slug_title = mock

      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:user_name, user_name)
      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:slug_title, slug_title)

      interactor = described_class.new user_name, slug_title
    end
  end
end
