require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/interacting_users_impact_for_fact.rb'

describe Queries::Opinions::InteractingUsersImpactForFact do
  include PavlovSupport

  before do
    stub_classes 'OpinionPresenter', 'Fact', 'Opinion::Store', 'HashStore::Redis'
  end

  it 'should retrieve impact for a fact and opinion type' do
    fact = mock :fact, id: '3'
    type = mock
    user_opinion = mock
    opinion_store = mock
    query = described_class.new fact.id, type, current_user: mock

    Fact.stub(:[])
      .with(fact.id)
      .and_return(fact)

    HashStore::Redis.stub new: mock
    Opinion::Store.stub(:new).with(HashStore::Redis.new)
      .and_return(opinion_store)

    opinion_store.stub(:retrieve).with(:Fact, fact.id, :user_opinion)
      .and_return(user_opinion)

    opinion_presenter = mock
    OpinionPresenter
      .stub(:new)
      .with(user_opinion)
      .and_return(opinion_presenter)
    opinion = mock
    opinion_presenter.stub(:authority)
      .with(type)
      .and_return(opinion)

    expect(query.call).to eq opinion
  end
end
