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

      ReplyToConversationInteractor.should_receive(:new).
         with(conversation_id.to_s, user.id.to_s, 'verhaal', {current_user: user}).
         and_return(interactor)

      get :create, conversation_id: conversation_id, content: 'verhaal'
    end
  end
end
