require 'pavlov_helper'
require_relative '../../../app/interactors/interactors/search_user.rb'

describe Interactors::SearchUser do
  include PavlovSupport

  let(:relaxed_ability) { stub(:ability, can?: true)}

  before do
    stub_classes 'Topic', 'Queries::ElasticSearchUser',
                 'Fact','Ability::FactlinkWebapp'
  end

  it 'raises when initialized with keywords that is not a string' do
    interactor = described_class.new nil
    expect { interactor.call }
      .to raise_error(RuntimeError, 'Keywords should be a string.')
  end

  it 'raises when initialized with an empty keywords string' do
    interactor = described_class.new keywords: ''
    expect { interactor.call }
      .to raise_error(RuntimeError, 'Keywords must not be empty.')
  end

  describe '.initialize' do
    it 'raises when executed without any permission' do
      keywords = "searching for this user"
      ability = mock()
      ability.stub can?: false

      interactor = described_class.new keywords: keywords,
        pavlov_options: { ability: ability }

      expect { interactor.call }
        .to raise_error(Pavlov::AccessDenied)
    end
  end
  describe '.call' do
    it 'correctly' do
      keywords = 'searching for this user'
      interactor = described_class.new keywords: keywords,
        pavlov_options: { ability: relaxed_ability }
      user = mock()
      user.should_receive(:hidden).and_return(false)
      query = mock()
      query.should_receive(:call).
        and_return([user])
      Queries::ElasticSearchUser.should_receive(:new).
        with(keywords, 1, 20, ability: relaxed_ability).
        and_return(query)

      interactor.call.should eq [user]
    end

    it 'should not return hidden users' do
      keywords = 'searching for this user'
      interactor = described_class.new keywords: keywords,
        pavlov_options: { ability: relaxed_ability }
      user = mock()
      query = mock()
      user.should_receive(:hidden).and_return(true)
      query.should_receive(:call).
        and_return([user])
      Queries::ElasticSearchUser.should_receive(:new).
        with(keywords, 1, 20, ability: relaxed_ability).
        and_return(query)

      interactor.call.should eq []
    end
  end
end
