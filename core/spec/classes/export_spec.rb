require 'spec_helper'

describe Export do
  it '#export' do
    user = create :user, created_at: Time.at(0)
    user.updated_at = Time.at(1000)
    user.confirmation_token = 'moi'
    user.confirmation_sent_at = Time.at(2000)
    user.save!

    create :social_account, :twitter, user: user,
      created_at: Time.at(0), updated_at: Time.at(1000)

    verify(format: :text) { Export.new.export }
  end
end
