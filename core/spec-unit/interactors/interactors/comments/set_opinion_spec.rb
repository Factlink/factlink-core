require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/set_opinion.rb'


describe Interactors::Comments::SetOpinion do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = Interactors::Comments::SetOpinion.new '1', 'believes', current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { Interactors::Comments::SetOpinion.new '1', 'believes'}.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'with a invalid comment_id doesn''t validate' do
    expect { Interactors::Comments::SetOpinion.new 'g', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'with a invalid opinion doesn''t validate' do
    expect { Interactors::Comments::SetOpinion.new '1', 'dunno'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end

  describe '.execute' do
    before do
      stub_classes 'Commands::Comments::SetOpinion'
    end

    it 'does stuff' do
      opinion = 'believes'
      user = mock()
      comment = mock(id: '123abc456def')
      authority_string = '1.0'

      interactor = Interactors::Comments::SetOpinion.new comment.id, opinion, current_user: user

      interactor.should_receive(:command).with('comment/set_opinion', comment.id, opinion)

      interactor.should_receive(:comment).any_number_of_times.and_return(comment)
      interactor.should_receive(:authority_of).with(comment).and_return(authority_string)
      comment.should_receive(:authority=).with(authority_string)

      interactor.execute
    end
  end

  describe '.comment' do
    before do
      stub_classes 'Comment'
    end

    it 'returns a comment' do
      comment = mock(id: '123abc')
      opinion = 'believes'
      user    = mock()

      Comment.should_receive(:find).with(comment.id).and_return(comment)

      interactor = Interactors::Comments::SetOpinion.new comment.id, opinion, current_user: user
      interactor.comment.should eq comment
      interactor.comment.should eq comment # must cache
    end
  end

  describe '.authority_of' do
    it 'retrieves the authority' do
      fact_data = mock( fact: mock() )
      user      = mock( graph_user: mock() )
      comment   = mock(id: '123abc', fact_data: fact_data, created_by: user )
      opinion   = 'believes'
      authority = '2.0'

      interactor = Interactors::Comments::SetOpinion.new comment.id, opinion, current_user: user

      interactor.should_receive(:query).with(:authority_on_fact_for, comment.fact_data.fact, comment.created_by.graph_user).and_return(authority)

      interactor.authority_of(comment).should eq authority
    end
  end
end
