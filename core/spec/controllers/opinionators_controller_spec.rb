require 'spec_helper'

describe OpinionatorsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :index do
    it "should keep the same content" do
      FactoryGirl.reload

      fact_data = create :fact_data

      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
      end

      last_user = create :user
      as(last_user) do |pavlov|
        pavlov.interactor(:'facts/set_interesting', fact_id: fact_data.fact_id.to_s)
      end
      as(last_user) do |pavlov|
        pavlov.interactor(:'facts/remove_interesting', fact_id: fact_data.fact_id.to_s)
      end

      get :index, fact_id: fact_data.fact_id.to_s

      verify { response.body }
    end
  end
end
