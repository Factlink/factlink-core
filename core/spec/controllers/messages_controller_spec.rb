require 'spec_helper'

describe MessagesController do
  render_views

  let(:user) {create :user}

  describe :create do
    it "calls the correct interactor" do
      authenticate_user! user

      conversation_id = 10

      interactor = mock()
      interactor.should_receive(:execute)

      pavlov_options = mock()
      controller.should_receive(:pavlov_options).and_return(pavlov_options)

      Interactors::ReplyToConversation.should_receive(:new).
         with(conversation_id.to_s, user.id.to_s, 'verhaal', pavlov_options).
         and_return(interactor)

      get :create, conversation_id: conversation_id, content: 'verhaal'
    end
  end
end
