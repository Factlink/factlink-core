require 'spec_helper'

describe Export do
  include PavlovSupport

  it '#export' do
    FactoryGirl.reload

    user = create :user, created_at: Time.parse('1970-01-01T0:0:0Z')
    user.updated_at = Time.parse('1970-01-02T0:0:0Z')
    user.confirmation_token = 'moi'
    user.confirmation_sent_at = Time.parse('1970-01-03T0:0:0Z')
    user.save!

    create :social_account, :twitter, user: user,
      created_at: Time.parse('1970-01-04T0:0:0Z'), updated_at: Time.parse('1970-01-05T0:0:0Z')

    fact_data = create :fact_data, created_at: Time.parse('1970-01-06T0:0:0Z'), updated_at: Time.parse('1970-01-07T0:0:0Z')

    as(user) do |pavlov|
      pavlov.time = Time.parse('1970-01-08T0:0:0Z')
      pavlov.interactor(:"comments/create", content: "I like plants.", fact_id: fact_data.fact_id)
    end

    verify(format: :text) { Export.new.export }
  end
end
