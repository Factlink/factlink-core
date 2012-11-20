require 'pavlov_helper'
require_relative '../../../app/interactors/queries/get_comments.rb'

describe Queries::GetComments do
  include PavlovSupport

  it 'initializes correctly' do
    query = Queries::GetComments.new 'a1', 'believes'

    query.should_not be_nil
  end

  it 'with an invalid fact_id should raise a validation error' do
    expect { Queries::GetComments.new 'g6', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an hexadecimal string.')
  end

  it 'with an invalid opinion should raise a validation error' do
    expect { Queries::GetComments.new 'a1', 'mwah'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_const('Comment',Class.new)
    end

    it 'correctly' do
      fact_data = mock(id: '3b')
      opinion = 'believes'
      query = Queries::GetComments.new fact_data.id, opinion
      comment = mock(content: 'bla', id: '1a', opinion: opinion, fact_data: fact_data)
      Comment.should_receive(:find).
        with(fact_data_id: fact_data.id, opinion: opinion).
        and_return([comment])

      results = query.execute

      results.should eq [comment]

    end
  end
end
