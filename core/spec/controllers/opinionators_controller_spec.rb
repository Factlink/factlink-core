require 'spec_helper'

describe OpinionatorsController do
  include PavlovSupport

  render_views

  let(:user) { create(:user) }

  describe :index do
    it "should keep the same content" do
      FactoryGirl.reload

      fact = create :fact

      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: fact.id, opinion: 'believes')
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: fact.id, opinion: 'disbelieves')
      end
      as(create :user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: fact.id, opinion: 'disbelieves')
      end

      last_user = create :user
      as(last_user) do |pavlov|
        pavlov.interactor(:'facts/set_opinion', fact_id: fact.id, opinion: 'disbelieves')
      end
      as(last_user) do |pavlov|
        pavlov.interactor(:'facts/remove_opinion', fact_id: fact.id)
      end

      get :index, fact_id: fact.id

      verify { response.body }
    end
  end
end
