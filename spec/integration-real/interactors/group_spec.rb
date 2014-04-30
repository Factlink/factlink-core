require 'spec_helper'

describe Interactors::Groups do
  include PavlovSupport

  describe 'Created groups appear in list' do
    it 'filters out invalid activities' do
      user = create :user, admin: true
      as(user) do |pavlov|
        groups0 = pavlov.interactor :'groups/list'
        expect(groups0.size).to eq 0
        pavlov.interactor :'groups/create', groupname: "bla", members: []
        groups1 = pavlov.interactor :'groups/list'
        expect(groups1.size).to eq 1
      end
    end
  end
end
