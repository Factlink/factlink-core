require 'spec_helper'

describe Export do
  it '#export' do
    FactoryGirl.reload

    user = create :user, created_at: Time.parse('1970-01-01T0:0:0Z')
    user.updated_at = Time.parse('1970-01-02T0:0:0Z')
    user.confirmation_token = 'moi'
    user.confirmation_sent_at = Time.parse('1970-01-03T0:0:0Z')
    user.save!

    create :social_account, :twitter, user: user,
      created_at: Time.parse('1970-01-04T0:0:0Z'), updated_at: Time.parse('1970-01-05T0:0:0Z')

    create :fact_data, created_at: Time.parse('1970-01-06T0:0:0Z'), updated_at: Time.parse('1970-01-07T0:0:0Z')

    verify(format: :text) { Export.new.export }
  end
end
