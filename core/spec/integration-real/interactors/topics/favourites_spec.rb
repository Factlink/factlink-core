require 'spec_helper'

describe 'favouriting topics' do
  include Pavlov::Helpers
  include PavlovSupport

  let(:current_user) { create :user }
  let(:other_user)   { create :user }
  let(:topic1)       { create :topic }
  let(:topic2)       { create :topic }
  let(:ability)      { mock(can?: true) }

  before do
    Interactors::Topics::Favourite.any_instance.stub :track
    Interactors::Topics::Unfavourite.any_instance.stub :track
  end

  def pavlov_options
    {current_user: current_user, ability: ability}
  end

  describe 'user initially' do
    it 'has no favourites' do
      results = interactor :'topics/favourites', current_user.username

      expect(results.size).to eq 0
    end
  end

  describe 'user favouriting two topics' do
    before do
      interactor :'topics/favourite', current_user.username, topic1.slug_title
      interactor :'topics/favourite', current_user.username, topic2.slug_title
    end

    it 'has two favourites' do
      results = interactor :'topics/favourites', current_user.username
      titles = results.map(&:title)

      expect(results.size).to eq 2
      expect(titles).to include topic1.title
      expect(titles).to include topic2.title
    end

    it 'has still two favourites after favouriting one again' do
      interactor :'topics/favourite', current_user.username, topic1.slug_title

      results = interactor :'topics/favourites', current_user.username
      titles = results.map(&:title)

      expect(results.size).to eq 2
      expect(titles).to include topic1.title
      expect(titles).to include topic2.title
    end

    describe 'user after unfavouriting the second topic' do
      before do
        interactor :'topics/unfavourite', current_user.username, topic2.slug_title
      end

      it 'has one favourite' do
        results = interactor :'topics/favourites', current_user.username

        expect(results.size).to eq 1
        expect(results[0].title).to eq topic1.title
      end

      it 'still has one favourite after unfavouriting the same one again' do
        interactor :'topics/unfavourite', current_user.username, topic2.slug_title

        results = interactor :'topics/favourites', current_user.username

        expect(results.size).to eq 1
        expect(results[0].title).to eq topic1.title
      end
    end
  end

  describe 'two users favouriting one topic' do
    before do
      interactor :'topics/favourite', current_user.username, topic1.slug_title
      interactor :'topics/favourite', other_user.username, topic1.slug_title
    end

    it 'current_user has one favourite' do
      results = interactor :'topics/favourites', current_user.username

      expect(results.size).to eq 1
      expect(results[0].title).to eq topic1.title
    end
  end

end
