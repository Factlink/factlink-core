require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/interacting_users_impact_for_fact.rb'

describe Queries::Opinions::InteractingUsersImpactForFact do
  include PavlovSupport

  before do
    stub_classes 'OpinionPresenter', 'Fact', 'Opinion::BaseFactCalculation'
  end

  it 'should retrieve impact for a fact and opinion type' do
    user = mock :user, graph_user: mock
    fact = mock :fact, id: '3'
    type = mock
    user_opinion = mock
    base_fact_calculation = mock get_user_opinion: user_opinion
    query = described_class.new fact.id, type, current_user: user

    Fact.stub(:[])
      .with(fact.id)
      .and_return(fact)

    Opinion::BaseFactCalculation.stub(:new).with(fact)
      .and_return(base_fact_calculation)

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
