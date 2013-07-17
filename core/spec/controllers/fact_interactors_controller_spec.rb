require 'spec_helper'

describe FactInteractorsController do
  include PavlovSupport

  render_views

  let(:user) { FactoryGirl.create(:user) }

  describe :show do
    it "should render successful" do
      fact = create :fact

      5.times do
        fact.add_opiniated :disbelieves, (create :user).graph_user
      end

      get :interactors, id: fact.id, type: 'disbelieves'
      response.should be_success
    end
  end

end
