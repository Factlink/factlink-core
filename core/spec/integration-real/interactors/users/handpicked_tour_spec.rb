require 'spec_helper'

describe 'user following' do
  include PavlovSupport

  let(:user) { create :user }
  let(:handpicked_user) { create :user }

  describe 'initially' do
    it 'shows no tour users' do
      as(user) do |pavlov|
        result = pavlov.interactor :'users/tour_users'
        expect(result.size).to eq 0
      end
    end

    it "allows for removing users that are not in the list" do
      as(user) do |pavlov|
        pavlov.command :'users/remove_handpicked_user', user_id: handpicked_user.id.to_s

        result = pavlov.interactor :'users/tour_users'
        expect(result.size).to eq 0
      end
    end
  end

  describe 'adding a handpicked user' do
    it 'shows up in the tour users list' do
      as(user) do |pavlov|
        pavlov.command :'users/add_handpicked_user', user_id: handpicked_user.id.to_s

        result = pavlov.interactor :'users/tour_users'
        expect(result.size).to eq 1
        expect(result[0].username).to eq handpicked_user.username
      end
    end

    it "also shows up in the user's own tour users list" do
      as(user) do |pavlov|
        pavlov.command :'users/add_handpicked_user', user_id: handpicked_user.id.to_s
      end
      as(handpicked_user) do |pavlov|
        result = pavlov.interactor :'users/tour_users'
        expect(result.size).to eq 1
        expect(result[0].username).to eq handpicked_user.username
      end
    end

    it "doens't show up after removing again" do
      as(user) do |pavlov|
        pavlov.command :'users/add_handpicked_user', user_id: handpicked_user.id.to_s
        pavlov.command :'users/remove_handpicked_user', user_id: handpicked_user.id.to_s

        result = pavlov.interactor :'users/tour_users'
        expect(result.size).to eq 0
      end
    end
  end
end
