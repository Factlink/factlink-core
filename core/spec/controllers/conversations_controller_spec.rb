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
    it "calls the correct interactor" do
      authenticate_user! user

      other_guy = create :user
      fact_id = 10

      pavlov_options = double
      controller.stub(pavlov_options: pavlov_options)

      users = ['henk','frits']
      Pavlov.should_receive(:interactor)
            .with :'create_conversation_with_message', fact_id: fact_id.to_s,
                      recipient_usernames: users, sender_id: user.id.to_s,
                      content: 'verhaal', pavlov_options: pavlov_options

      get :create, fact_id: fact_id, recipients: users, content: 'verhaal'
    end
  end
end
