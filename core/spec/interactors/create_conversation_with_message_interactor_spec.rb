require 'spec_helper'

describe CreateConversationWithMessageInteractor do
  it "creates a conversation" do
    jan = create :user, username: 'jan'
    frank = create :user, username: 'frank'

    CreateConversationWithMessageInteractor.perform [jan.username, frank.username], jan.username, 'geert'
    expect(Conversation.all.length.should).to eq(1)

    conversation = Conversation.all.first

    expect(conversation.messages.length).to eq(1)
    expect(conversation.messages[0].content).to eq('geert')
  end
end
