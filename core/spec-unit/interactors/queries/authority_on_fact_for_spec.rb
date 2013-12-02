require 'pavlov_helper'
require_relative '../../../app/interactors/queries/authority_on_fact_for.rb'

describe Queries::AuthorityOnFactFor do
  include PavlovSupport

  describe '#call' do
    it 'should return "1.0"' do
      fact = double
      graph_user = double

      query = described_class.new fact: fact, graph_user: graph_user

      expect( query.call ).to eq "1.0"
    end
  end
end
