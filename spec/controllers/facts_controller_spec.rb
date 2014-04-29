require 'spec_helper'

describe FactsController do
  render_views

  describe "GET discussion_page_redirect" do
    it "redirects to proxy" do
      fact_data = create :fact_data, site_url: 'http://example.org/'

      get :discussion_page_redirect, id: fact_data.fact_id.to_s

      response.should redirect_to('http://localhost:8080/?url=http%3A%2F%2Fexample.org%2F#factlink-open-1')
    end
  end
end
