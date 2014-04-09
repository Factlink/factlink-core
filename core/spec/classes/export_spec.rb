require 'spec_helper'

describe Export do
  it '#export' do
    FactoryGirl.reload

    user = create :user, created_at: Time.at(0)
    user.updated_at = Time.at(1000)
    user.confirmation_token = 'moi'
    user.confirmation_sent_at = Time.at(2000)
    user.save!

    create :social_account, :twitter, user: user,
      created_at: Time.at(3000), updated_at: Time.at(4000)

    create :fact_data, created_at: Time.at(5000), updated_at: Time.at(6000)

    verify(format: :text) { Export.new.export }
  end
end
