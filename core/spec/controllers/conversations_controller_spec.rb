require 'spec_helper'

describe ConversationsController do
  render_views

  let(:conv) {create(:conversation_with_messages, message_count: 4, user_count: 3)}

  describe :show do
    describe "json" do
      it "should contain conversation fields" do 
        get :show, id: conv.id.to_s, format: 'json'
        expect(response).to be_success
        json = JSON.parse(response.body)

        expect(json["id"]).to eq(conv.id.to_s)
        expect(json["fact_data_id"]).to eq(conv.fact_data.id.to_s)
      end

      it "should contain messages" do
        get :show, id: conv.id.to_s, format: 'json'
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json["messages"][0]["id"]).to eq(conv.messages[0].id.to_s)
        expect(json["messages"][1]["sender_id"]).to eq(conv.messages[1].sender.id.to_s)
        expect(json["messages"][2]["content"]).to eq(conv.messages[2].content)
      end
    end
    
    describe "html" do
      it "should be successful" do
        get :show, id: 0
        expect(response).to be_success
      end
    end
  end
end
