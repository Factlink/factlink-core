require 'spec_helper'

describe MessagesController do
  render_views

  let(:user) {create :full_user}

  describe :create do
    it "adds a message when passed in a correct message" do
      authenticate_user! user

      conversation = create :conversation, recipients: [user]

      get :create, conversation_id: conversation.id, content: 'verhaal'
      expect(response).to be_success

      refetched_conversation = Conversation.find(conversation.id)
      expect(refetched_conversation.messages.length).to eq 1
    end

    it "returns an error message when the content is invalid" do
      authenticate_user! user

      conversation = create :conversation, recipients: [user]

      get :create, conversation_id: conversation.id, content: ''

      expect(response).to_not be_success
      expect(response.status).to eq 400
      expect(response.body).to eq 'Content cannot be empty'
    end
  end
end
