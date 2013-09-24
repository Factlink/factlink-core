require 'spec_helper'

describe 'favouriting topics' do
  include PavlovSupport

  let(:user1) { create :full_user }
  let(:user2) { create :full_user }

  before do
    Interactors::Topics::Favourite.any_instance.stub :mp_track
    Interactors::Topics::Unfavourite.any_instance.stub :mp_track
  end

  describe 'user initially' do
    it 'has no favourites' do
      as(user1) do |pavlov|
        results = pavlov.interactor(:'topics/favourites', user_name: user1.username)
        expect(results.size).to eq 0
      end
    end
  end

  describe 'user favouriting two topics' do
    it 'has two favourites' do
      as(user1) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Title 1')
        topic2 = pavlov.command(:'topics/create', title: 'Title 2')

        pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic1.slug_title)
        pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic2.slug_title)

        results = pavlov.interactor(:'topics/favourites', user_name: user1.username)
        titles = results.map(&:title)

        expect(results.size).to eq 2
        expect(titles).to include topic1.title
        expect(titles).to include topic2.title
      end
    end

    it 'has still two favourites after favouriting one again' do
      as(user1) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Title 1')
        topic2 = pavlov.command(:'topics/create', title: 'Title 2')

        pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic1.slug_title)
        pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic2.slug_title)

        pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic1.slug_title)

        results = pavlov.interactor(:'topics/favourites', user_name: user1.username)
        titles = results.map(&:title)

        expect(results.size).to eq 2
        expect(titles).to include topic1.title
        expect(titles).to include topic2.title
      end
    end

    describe 'user after unfavouriting the second topic' do
      it 'has one favourite' do
        as(user1) do |pavlov|
          topic1 = pavlov.command(:'topics/create', title: 'Title 1')
          topic2 = pavlov.command(:'topics/create', title: 'Title 2')

          pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic1.slug_title)
          pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic2.slug_title)
          pavlov.interactor(:'topics/unfavourite', user_name: user1.username, slug_title: topic2.slug_title)

          results = pavlov.interactor(:'topics/favourites', user_name: user1.username)
          expect(results.size).to eq 1
          expect(results[0].title).to eq topic1.title
        end
      end

      it 'still has one favourite after unfavouriting the same one again' do
        as(user1) do |pavlov|
          topic1 = pavlov.command(:'topics/create', title: 'Title 1')
          topic2 = pavlov.command(:'topics/create', title: 'Title 2')

          pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic1.slug_title)
          pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic2.slug_title)
          pavlov.interactor(:'topics/unfavourite', user_name: user1.username, slug_title: topic2.slug_title)

          pavlov.interactor(:'topics/unfavourite', user_name: user1.username, slug_title: topic2.slug_title)

          results = pavlov.interactor(:'topics/favourites', user_name: user1.username)
          expect(results.size).to eq 1
          expect(results[0].title).to eq topic1.title
        end
      end
    end
  end

  describe 'two users favouriting one topic' do
    it 'user1 has one favourite' do
      topic1, topic2 = ()

      as(user1) do |pavlov|
        topic1 = pavlov.command(:'topics/create', title: 'Title 1')
        topic2 = pavlov.command(:'topics/create', title: 'Title 2')
      end

      as(user1) do |pavlov|
        pavlov.interactor(:'topics/favourite', user_name: user1.username, slug_title: topic1.slug_title)
      end
      as(user2) do |pavlov|
        pavlov.interactor(:'topics/favourite', user_name: user2.username, slug_title: topic1.slug_title)
      end

      as(user1) do |pavlov|
        results = pavlov.interactor(:'topics/favourites', user_name: user1.username)
        expect(results.size).to eq 1
        expect(results[0].title).to eq topic1.title
      end
    end
  end

end
