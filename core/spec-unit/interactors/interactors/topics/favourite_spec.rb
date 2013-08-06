require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/favourite'

describe Interactors::Topics::Favourite do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance
        .stub(validate: true)
    end

    it 'throws when no current_user' do
      expect { described_class.new(user_name: double, slug_title: double).call }
        .to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when cannot edit favourites' do
      user = double
      current_user = double
      ability = double

      ability.stub(:can?).with(:edit_favourites, user).and_return(false)

      pavlov_options = { current_user: current_user, ability: ability }

      Pavlov.stub(:old_query)
        .with(:user_by_username, 'username', pavlov_options)
        .and_return(user)

      interactor = described_class.new user_name: 'username',
                    slug_title: 'slug_title',
                    pavlov_options: pavlov_options

      expect { interactor.call }.
        to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls a command to favourite topic' do
      user_name = 'henk'
      slug_title = 'slug'
      current_user = double
      user = double(graph_user_id: double)

      ability = double
      ability.stub(:can?).with(:edit_favourites, user).and_return(true)

      pavlov_options = { current_user: current_user, ability: ability }

      interactor = described_class.new user_name: user_name,
        slug_title: slug_title, pavlov_options: pavlov_options

      topic = double(id: double)

      Pavlov.stub(:old_query)
        .with(:'user_by_username', user_name, pavlov_options)
        .and_return(user)
      Pavlov.stub(:old_query)
        .with(:'topics/by_slug_title', slug_title, pavlov_options)
        .and_return(topic)
      Pavlov.should_receive(:old_command)
        .with(:'topics/favourite', user.graph_user_id, topic.id.to_s, pavlov_options)

      interactor.should_receive(:mp_track)
        .with('Topic: Favourited', slug_title: slug_title)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'with invalid user_name doesn\'t validate' do
      expect_validating(user_name: '', slug_title: 'title')
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating(user_name: 'karel', slug_title: '')
        .to fail_validation('slug_title should be a nonempty string.')
    end
  end
end
