require 'spec_helper'

describe ConversationsController do
  let(:user) { create :full_user}

  describe :index do
    it "calls the correct query" do
      authenticate_user! user

      conversation = double(:conversation, )

      pavlov_options = double
      controller.stub(pavlov_options: pavlov_options)

      Pavlov
        .should_receive(:query)
        .with(:'conversations_with_users_message', user_id: user.id.to_s, pavlov_options: pavlov_options)
        .and_return([conversation])

      get :index, format: 'json'
      response.should render_template('conversations/index')
    end
  end

  describe :show do
    render_views

    let(:conv) do
      c = create(:conversation_with_messages, message_count: 4, user_count: 3)
      c.recipients << user
      c.save
      c
    end

    describe "json" do
      it "should contain conversation fields" do
        authenticate_user!(user)

        get :show, id: conv.id.to_s, format: 'json'
        expect(response).to be_success
        json = JSON.parse(response.body)

        expect(json["id"]).to eq(conv.id.to_s)
        expect(json["fact_data_id"]).to eq(conv.fact_data.id.to_s)
        expect(json["fact_id"]).to eq(conv.fact_data.fact_id.to_s)
      end

      it "should contain messages" do
        authenticate_user!(user)

        get :show, id: conv.id.to_s, format: 'json'
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json["messages"][0]["id"]).to eq(conv.messages[0].id.to_s)
        expect(json["messages"][1]["sender"]["id"]).to eq(conv.messages[1].sender.id.to_s)
        expect(json["messages"][2]["content"]).to eq(conv.messages[2].content)
      end
    end

    describe "html" do
      it "should be successful" do
        authenticate_user! user
        get :show, id: 0
        expect(response).to be_success
      end
    end
  end

  describe :create do
    it "creates a conversation" do
      authenticate_user! user

      other_guy = create :full_user
      fact = create :fact

      get :create, fact_id: fact.id, recipients: [other_guy.username, user.username], content: 'verhaal'
      expect(response).to be_success

      user_conversations = User.find(user.id).conversations
      other_guy_conversations = User.find(other_guy.id).conversations
      expect(user_conversations.length).to eq 1
      expect(other_guy_conversations.length).to eq 1
    end

    it "returns an error message when the message is incorrect" do
      authenticate_user! user

      fact = create :fact
      content = ''

      get :create, fact_id: fact.id, recipients: [user.username], content: content

      expect(response).to_not be_success
      expect(response.status).to eq 400
      expect(response.body).to eq 'Content cannot be empty'
    end
  end
end
