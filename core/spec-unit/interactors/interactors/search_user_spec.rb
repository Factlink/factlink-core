require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/search_user.rb'

describe Interactors::SearchUser do
  include PavlovSupport

  let(:relaxed_ability) { stub(:ability, can?: true)}

  before do
    stub_classes 'Topic', 'Queries::ElasticSearchUser',
                 'Fact','Ability::FactlinkWebapp'
  end

  it 'initializes' do
    interactor = Interactors::SearchUser.new 'keywords', ability: relaxed_ability
    interactor.should_not be_nil
  end

  it 'raises when initialized with keywords that is not a string' do
    expect { interactor = Interactors::SearchUser.new nil }.
      to raise_error(RuntimeError, 'Keywords should be a string.')
  end

  it 'raises when initialized with an empty keywords string' do
    expect { interactor = Interactors::SearchUser.new '' }.
      to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      keywords = "searching for this user"
      ability = mock()
      ability.stub can?: false

      expect do
        Interactors::SearchUser.new keywords, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '.execute' do
    it 'correctly' do
      keywords = 'searching for this user'
      interactor = Interactors::SearchUser.new keywords, ability: relaxed_ability
      topic = mock()
      query = mock()
      query.should_receive(:execute).
        and_return([topic])
      Queries::ElasticSearchUser.should_receive(:new).
        with(keywords, 1, 20).
        and_return(query)

      interactor.execute.should eq [topic]
    end
  end
end
