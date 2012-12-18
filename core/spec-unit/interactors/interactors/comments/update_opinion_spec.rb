require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/update_opinion.rb'


describe Interactors::Comments::UpdateOpinion do
  include PavlovSupport

  it 'initializes correctly' do
    user = mock()
    interactor = Interactors::Comments::UpdateOpinion.new '1', 'believes', current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { Interactors::Comments::UpdateOpinion.new '1', 'believes'}.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'with a invalid comment_id doesn''t validate' do
    expect { Interactors::Comments::UpdateOpinion.new 'g', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'with a invalid opinion doesn''t validate' do
    expect { Interactors::Comments::UpdateOpinion.new '1', 'dunno'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts", nil].')
  end

  describe '.call' do
    before do
      stub_classes 'Commands::Comments::SetOpinion'
    end

    it 'call the set_opinion command when an opinion is being set' do
      opinion = 'believes'
      user = mock( graph_user: mock() )
      comment = mock(id: '123abc456def')
      authority_string = '1.0'

      mock_comment = mock

      interactor = Interactors::Comments::UpdateOpinion.new comment.id, opinion, current_user: user

      interactor.should_receive(:command).with('comments/set_opinion', comment.id, opinion, user.graph_user)
      interactor.should_receive(:query).with(:'comments/get', comment.id).and_return(mock_comment)

      expect(interactor.call).to eq mock_comment
    end

    it 'calls the remove_opinion command when no opinion is passed' do
      user = mock( graph_user: mock() )
      comment = mock(id: '123abc456def')
      authority_string = '1.0'

      mock_comment = mock

      interactor = Interactors::Comments::UpdateOpinion.new comment.id, nil, current_user: user

      interactor.should_receive(:command).with('comments/remove_opinion', comment.id, user.graph_user)
      interactor.should_receive(:query).with(:'comments/get', comment.id).and_return(mock_comment)

      expect(interactor.call).to eq mock_comment
    end
  end
end
