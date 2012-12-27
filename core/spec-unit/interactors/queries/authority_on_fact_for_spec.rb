require 'pavlov_helper'
require_relative '../../../app/interactors/queries/authority_on_fact_for.rb'

describe Queries::AuthorityOnFactFor do
  include PavlovSupport

  it 'initializes correctly' do
    query = Queries::AuthorityOnFactFor.new mock(:fact, id: 10), mock(:graph_user, id: 20)
    query.should_not be_nil
  end

  describe '.call' do
    before do
      stub_classes 'Comment', 'Authority'
    end

    it 'should return the authority of the current_user on a comment' do
      fact = mock(:fact, id: 10)
      graph_user = mock(:graph_user, id: 20)

      authority = mock
      authority_string = '1.0'

      query = Queries::AuthorityOnFactFor.new fact, graph_user

      Authority.should_receive(:on).with(fact, for: graph_user).and_return(authority)
      authority.should_receive(:to_s).with(1.0).and_return(authority_string)

      query.call.should eq authority_string
    end
  end
end
