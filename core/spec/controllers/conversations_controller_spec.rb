require 'spec_helper'

describe ConversationsController do
  render_views

  let(:conv) {create(:conversation_with_messages, message_count: 10, user_count: 3)}

  describe :show do
    it "should show" do 
      get :show, id: conv.id.to_s, format: 'json'
      # require 'debugger'; debugger
      # puts 'bla'
      # puts 'bla'
      # puts 'bla'
      # puts 'bla'
      # puts response.inspect
    end
  end
end

# expect(parsed_content["fact_bubble"]["displaystring"]).to eq(displaystring)
