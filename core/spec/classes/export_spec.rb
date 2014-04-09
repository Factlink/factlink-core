require 'spec_helper'

describe Export do
  include PavlovSupport

  it '#export' do
    FactoryGirl.reload

    user = create :user, created_at: Time.at(0)
    user.updated_at = Time.at(1000)
    user.confirmation_token = 'moi'
    user.confirmation_sent_at = Time.at(2000)
    user.save!

    create :social_account, :twitter, user: user,
      created_at: Time.at(3000), updated_at: Time.at(4000)

    fact_data = create :fact_data, created_at: Time.at(5000), updated_at: Time.at(6000)

    as(user) do |pavlov|
      pavlov.time = Time.at(7000)
      pavlov.interactor(:"comments/create", content: "I like plants.", fact_id: fact_data.fact_id)
    end

    verify(format: :text) { Export.new.export }
  end
end
