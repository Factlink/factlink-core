require 'spec_helper'

describe MessagesController do
  render_views

  let(:user) {create :user}

  describe :create do
    it "calls the correct interactor" do
      authenticate_user! user

      conversation_id = 10

      pavlov_options = mock()
      controller.stub(pavlov_options: pavlov_options)

      Pavlov.should_receive(:old_interactor)
        .with(:reply_to_conversation, conversation_id.to_s, user.id.to_s, 'verhaal', pavlov_options)

      get :create, conversation_id: conversation_id, content: 'verhaal'
    end
  end
end
