require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/interacting_users_impact_for_fact.rb'

describe Queries::Opinions::InteractingUsersImpactForFact do
  include PavlovSupport

  before do
    stub_classes 'FactGraph', 'Fact', 'OpinionPresenter'
  end

  it 'should retrieve impact for a fact and opinion type' do
    fact = mock :fact, id: '3'
    type = mock

    user_opinion = mock
    fact_graph = mock
    pavlov_options = { current_user: mock }

    query = described_class.new fact_id: fact.id, type: type,
              pavlov_options: pavlov_options

    Fact.stub(:[])
      .with(fact.id)
      .and_return(fact)

    FactGraph.stub new: fact_graph

    fact_graph.stub(:user_opinion_for_fact).with(fact)
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
