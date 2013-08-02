require 'pavlov_helper'
require_relative '../../../app/interactors/queries/authority_on_fact_for.rb'

describe Queries::AuthorityOnFactFor do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Comment', 'Authority'
    end

    it 'should return the authority of the current_user on a comment' do
      fact = double(:fact, id: 10)
      graph_user = double(:graph_user, id: 20)

      authority = double
      authority_string = '3.0'

      query = described_class.new fact: fact, graph_user: graph_user

      Authority.stub(:on)
        .with(fact, for: graph_user)
        .and_return(authority)
      authority
        .stub(:to_s)
        .with(1.0).and_return(authority_string)

      expect( query.call ).to eq authority_string
    end
  end
end
