require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/recently_viewed.rb'

describe Interactors::Facts::RecentlyViewed do
  include PavlovSupport

  before do
    stub_classes 'RecentlyViewedFacts', 'KillObject', 'Fact'
  end

  describe 'authorization' do
    it 'raises when the user cannot index facts' do
      ability = mock
      ability.stub(:can?)
             .with(:index, Fact)
             .and_return(false)

      expect { described_class.new(ability: ability).call }.
        to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'calls RecentlyViewedFacts.top' do
      user = mock id: '20e'
      recently_viewed_facts = mock
      fact = mock
      ability = mock can?: true

      RecentlyViewedFacts.stub(:by_user_id).with(user.id)
                         .and_return(recently_viewed_facts)

      recently_viewed_facts
        .stub(:top)
        .with(5)
        .and_return([fact])

      interactor = described_class.new(current_user: user, ability: ability)
      recent_facts = interactor.call

      expect(recent_facts).to eq [fact]
    end


    end
  end
end
