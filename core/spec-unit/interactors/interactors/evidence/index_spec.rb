require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/evidence/index.rb'

describe Interactors::Evidence::Index do
  include PavlovSupport

  it 'initializes correctly' do
    interactor = Interactors::Evidence::Index.new 1, :weakening, current_user: mock()
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Interactors::Evidence::Index }

    it 'requires fact_id to be an integer' do
      expect_validating('', :weakening).
        to fail_validation('fact_id should be an integer.')
    end

    it 'requires type be :weakening or :supporting' do
      expect_validating(1, :bla).
        to fail_validation('type should be on of these values: [:weakening, :supporting].')
    end
  end
  # it 'with an invalid fact_id should raise a validation error' do
  #   expect { Interactors::Comments::Index.new 'a', 'believes', current_user: mock()}.
  #     to raise_error(Pavlov::ValidationError, 'fact_id should be an integer.')
  # end

  # it 'with an invalid type should raise a validation error' do
  #   expect { Interactors::Comments::Index.new 1, 'mwah', current_user: mock()}.
  #     to raise_error(Pavlov::ValidationError, 'type should be on of these values: ["believes", "disbelieves", "doubts"].')
  # end

  # it 'without a current_user should raise a access error' do
  #   expect { Interactors::Comments::Index.new 1, 'believes' }.
  #     to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  # end

  # describe '.call' do
  #   it 'returns comments with the type object set' do
  #     fact = mock(id: 1)
  #     type = 'believes'
  #     user = mock()
  #     interactor = Interactors::Comments::Index.new fact.id, type, current_user: user
  #     comment1 = mock(id: '1a', content: 'text')
  #     comment2 = mock(id: '2a', content: 'text')

  #     interactor.should_receive(:fact).any_number_of_times.and_return(fact)

  #     interactor.should_receive(:query).with(:comments_for_fact_and_type, fact.id, type).and_return([comment1, comment2])

  #     result = interactor.call

  #     result.should eq [comment1, comment2]
  #   end
  # end

  # describe '.fact' do
  #   before do
  #     stub_classes 'Fact'
  #   end

  #   it 'returns the fact' do
  #     fact = mock(id: 3)
  #     type = 'believes'
  #     comment = mock()
  #     user = mock()

  #     interactor = Interactors::Comments::Index.new fact.id, type, current_user: user

  #     Fact.should_receive(:[]).with(fact.id).and_return(fact)

  #     interactor.fact.should eq fact
  #   end
  # end
end
