require 'spec_helper'

describe ConversationsController do
  let(:f) {create(:fact)}
  let(:u1) {create(:user)}
  let(:u2) {create(:user)}
  let(:u3) {create(:user)}
  let(:m1) {create(:message, sender: u1)}
  let(:m2) {create(:message, sender: u2)}
  let(:m3) {create(:message, sender: u3)}
  let(:m4) {create(:message, sender: u2)}

  let(:conv) do
    create(:conversation, subject: f.data, recipients: [u1, u2, u3], messages: [m1, m2, m3, m4])
  end

  describe :show do
    it "should show" do
      get :show, id: conv.id.to_s, format: 'json'
      # puts response
    end
  end
end

# expect(parsed_content["fact_bubble"]["displaystring"]).to eq(displaystring)
