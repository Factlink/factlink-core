require 'spec_helper'

describe ClientController do
  let(:user) { create(:full_user) }

  describe :show do
    render_views

    it "should render html for logged in user" do
      FactoryGirl.reload
      authenticate_user!(user)


      get :show, page: 'blank', format: :html

      response_body = response.body
        .gsub(/"id":"[^"]*"/, '"id: "#ID#"')
        .gsub(/"created_at":"[^"]*"/, '"created_at: "#CREATED_AT#"')
        .gsub(/mixpanel.identify\("[^"]*"\)/, 'mixpanel.identify("#IDENTITY#")')
        .gsub(/localStorage.factlink_csrf_token\s+=\s+"[^"]*"/, 'localStorage.factlink_csrf_token = "#CSRF_TOKEN#"')

      verify(format: :html) { response_body }
    end
  end
end
