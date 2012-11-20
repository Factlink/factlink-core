require 'pavlov_helper'
require_relative '../../app/interactors/get_comments_for_fact.rb'

describe GetCommentsForFact do
  include PavlovSupport

  it 'initializes corretly' do
    interactor = GetCommentsForFact.new '1', 'believes', current_user: mock()
    interactor.should_not be_nil
  end

  it 'with an invalid fact_id should raise a validation error' do
    expect { GetCommentsForFact.new 'g6', 'believes', current_user: mock()}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an hexadecimal string.')
  end

  it 'with an invalid opinion should raise a validation error' do
    expect { GetCommentsForFact.new 'a1', 'mwah', current_user: mock()}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  it 'without a current_user should raise a access error' do
    expect { GetCommentsForFact.new 'a1', 'believes' }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    it 'correctly' do
      fact_id = 'a1'
      opinion = 'believes'
      user = mock()
      interactor = GetCommentsForFact.new fact_id, opinion, current_user: user
      comment = mock(id: 1, content: 'text')
      interactor.should_receive(:query).with(:get_comments, fact_id, opinion).and_return([comment])

      result = interactor.execute

      result.should eq [comment]
    end
  end
end
