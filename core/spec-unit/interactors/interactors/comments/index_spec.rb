require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/index.rb'

describe Interactors::Comments::Index do
  include PavlovSupport

  it 'initializes corretly' do
    interactor = Interactors::Comments::Index.new 1, 'believes', current_user: mock()
    interactor.should_not be_nil
  end

  it 'with an invalid fact_id should raise a validation error' do
    expect { Interactors::Comments::Index.new 'a', 'believes', current_user: mock()}.
      to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  end

  it 'with an invalid opinion should raise a validation error' do
    expect { Interactors::Comments::Index.new 1, 'mwah', current_user: mock()}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  it 'without a current_user should raise a access error' do
    expect { Interactors::Comments::Index.new 1, 'believes' }.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  describe '.execute' do
    it 'returns comments with the opinion object set' do
      fact = mock(id: 1)
      opinion = 'believes'
      user = mock()
      interactor = Interactors::Comments::Index.new fact.id, opinion, current_user: user
      comment1 = mock(id: '1a', content: 'text')
      comment2 = mock(id: '2a', content: 'text')

      interactor.should_receive(:fact).any_number_of_times.and_return(fact)

      interactor.should_receive(:query).with(:comments_for_fact_and_opinion, fact.id, opinion).and_return([comment1, comment2])

      result = interactor.execute

      result.should eq [comment1, comment2]
    end
  end

  describe '.fact' do
    before do
      stub_classes 'Fact'
    end

    it 'returns the fact' do
      fact = mock(id: 3)
      opinion = 'believes'
      comment = mock()
      user = mock()

      interactor = Interactors::Comments::Index.new fact.id, opinion, current_user: user

      Fact.should_receive(:[]).with(fact.id).and_return(fact)

      interactor.fact.should eq fact
    end
  end
end
