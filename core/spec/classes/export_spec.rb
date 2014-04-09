require 'spec_helper'

describe Export do
  it '#export' do
    FactoryGirl.reload

    user = create :user, created_at: Time.parse('1970-01-01')
    user.updated_at = Time.parse('1970-01-02')
    user.confirmation_token = 'moi'
    user.confirmation_sent_at = Time.parse('1970-01-03')
    user.save!

    create :social_account, :twitter, user: user,
      created_at: Time.parse('1970-01-04'), updated_at: Time.parse('1970-01-05')

    create :fact_data, created_at: Time.parse('1970-01-06'), updated_at: Time.parse('1970-01-07')

    verify(format: :text) { Export.new.export }
  end
end
