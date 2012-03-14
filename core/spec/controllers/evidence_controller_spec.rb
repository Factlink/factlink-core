require 'spec_helper'

describe EvidenceController do
  render_views

  let (:user) {FactoryGirl.create(:user)}

  let (:f1) {FactoryGirl.create(:fact)}
  let (:f2) {FactoryGirl.create(:fact)}
  let (:f3) {FactoryGirl.create(:fact)}

  before do
    @fr = f1.add_evidence(:supporting, f2, user)
  end

  describe :index do
    it "should show" do
      should_check_can :get_evidence, f1

      get 'index', :fact_id => f1.id, :format => 'json'
      response.should be_success
    end

    it "should show the correct evidence" do
      should_check_can :get_evidence, f1

      get 'index', :fact_id => f1.id, :format => 'json'
      parsed_content = JSON.parse(response.body)
      parsed_content[0]["fact_bubble"]["id"].should == f2.id
    end
  end

  describe :create do


    context "adding new evidence to a fact" do

      it "should fail" do
        authenticate_user!(user)

        should_check_can :add_evidence, f1

        post 'create', fact_id: f1.id, displaystring: "Nieuwe features van Mark", format: :json

        puts "Response:"
        puts response.body
        puts "-------"
        response.should be_success
      end

    end

    # context "adding a new fact as evidence to a fact" do
    #   puts "pending"
    # end

  end


  describe :set_opinion do
    it "should be able to set an opinion" do
      authenticate_user!(user)

      should_check_can :opinionate, @fr

      post 'set_opinion', fact_id: f1.id, supporting_evidence_id: @fr.id, type: :believes, format: :json

      response.should be_success

      parsed_content = JSON.parse(response.body)
      parsed_content.first.should have_key("fact_bubble")
    end
  end
end