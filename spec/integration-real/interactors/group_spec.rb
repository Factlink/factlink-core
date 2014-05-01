require 'spec_helper'

describe Interactors::Groups do
  include PavlovSupport

  describe 'Created groups appear in list' do
    it 'Can create a group with no members' do
      user = create :user, admin: true
      user2 = create :user
      as(user) do |pavlov|
        groups0 = pavlov.interactor :'groups/list'
        expect(groups0.size).to eq 0
        group = pavlov.interactor :'groups/create', groupname: "bla", members: []
        groups1 = pavlov.interactor :'groups/list'
        expect(groups1.size).to eq 1
        # TODO: implement using interactor
        expect(Group.find(group.id).users.size).to eq 0
      end
    end
    it 'Can create a group with two members' do
      user = create :user, admin: true
      user2 = create :user
      as(user) do |pavlov|
        group = pavlov.interactor :'groups/create', groupname: "bla", members: [
            user.username, user2.username
        ]
        groups1 = pavlov.interactor :'groups/list'
        expect(groups1.size).to eq 1
        # TODO: implement using interactor
        expect(Group.find(group.id).users.size).to eq 2
      end
    end
  end
end
