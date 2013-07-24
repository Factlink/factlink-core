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
      expect { described_class.new(user_name: mock, slug_title: mock).call }
        .to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when cannot edit favourites' do
      user = stub
      current_user = stub
      ability = stub
      ability.stub(:can?).with(:edit_favourites, user).and_return(false)
      pavlov_options = { current_user: current_user, ability: ability }
      interactor = described_class.new(user_name: 'username',
        slug_title: 'slug_title', pavlov_options: pavlov_options)

      described_class.any_instance.stub(:old_query)
        .with(:user_by_username, 'username')
        .and_return(user)

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to favourite topic' do
      user_name = mock
      slug_title = mock
      interactor = described_class.new user_name: user_name,
        slug_title: slug_title
      user = mock(graph_user_id: mock)
      topic = mock(id: mock)

      interactor.stub(:old_query)
        .with(:'user_by_username', user_name)
        .and_return(user)
      interactor.stub(:old_query)
        .with(:'topics/by_slug_title', slug_title)
        .and_return(topic)
      interactor.should_receive(:old_command)
        .with(:'topics/favourite', user.graph_user_id, topic.id.to_s)
      interactor.should_receive(:mp_track)
        .with('Topic: Favourited', slug_title: slug_title)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'with invalid user_name doesn\'t validate' do
      expect_validating(user_name: 12, slug_title: 'title')
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating(user_name: 'karel', slug_title: 12)
        .to fail_validation('slug_title should be a nonempty string.')
    end
  end
end
