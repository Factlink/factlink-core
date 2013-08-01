require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/recently_viewed.rb'

describe Interactors::Facts::RecentlyViewed do
  include PavlovSupport

  before do
    stub_classes 'RecentlyViewedFacts', 'KillObject', 'Fact'
  end

  describe 'authorization' do
    it 'raises when the user cannot index facts' do
      ability = double
      ability.stub(:can?)
             .with(:index, Fact)
             .and_return(false)

      interactor = described_class.new(pavlov_options: { ability: ability })
      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '#call' do
    it 'calls RecentlyViewedFacts.top' do
      user = mock id: '20e'
      recently_viewed_facts = double
      fact = double
      ability = mock can?: true

      RecentlyViewedFacts.stub(:by_user_id).with(user.id)
                         .and_return(recently_viewed_facts)

      recently_viewed_facts
        .stub(:top)
        .with(5)
        .and_return([fact])

      interactor = described_class.new pavlov_options: { current_user: user,
        ability: ability }
      recent_facts = interactor.call

      expect(recent_facts).to eq [fact]
    end

    it 'returns an empty list when not logged in' do
      ability = mock can?: true
      interactor = described_class.new pavlov_options: { current_user: nil,
        ability: ability }
      recent_facts = interactor.call

      expect(recent_facts).to eq []
    end
  end
end
