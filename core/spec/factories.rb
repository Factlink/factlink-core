FactoryGirl.define do
  sequence :email do |n|
    "johndoe#{n}@example.com"
  end

  sequence :username do |n|
    "johndoe#{n}"
  end

  sequence :full_name do |n|
    "John#{n} Doe#{n}"
  end

  factory :user do
    username
    email
    full_name
    password '123hoi'
    password_confirmation '123hoi'

    trait :confirmed do
      confirmed_at DateTime.now
    end

    trait :admin do
      admin true
    end
  end

  factory :social_account do
    trait :twitter do
      provider_name 'twitter'
      omniauth_obj_string({
        uid: 'some_twitter_uid',
        provider: 'twitter',
        credentials: {token: 'token', secret: 'secret'},
        info: {'name' => 'Some Twitter Name'},
      }.to_json)
    end

    trait :facebook do
      provider_name 'facebook'
      omniauth_obj_string({
        uid: 'some_facebook_uid',
        provider: 'facebook',
        credentials: {token: 'token', expires_at: (DateTime.now + 4.weeks).to_i, expires: true},
        info: {name: 'Some Facebook Name'},
      }.to_json)
    end
  end

  sequence :displaystring do |n|
    "Fact #{n} " + 'bla' * 100
  end

  factory :fact_data do
    displaystring
    site_url
    sequence(:title) { |n| "Fact title #{n}" }
    sequence(:fact_id) { |n| "#{n}" }
  end

  factory :graph_user do
    # Never add an association with user here, it *does not work*, and *isnt desired*!
    # The reason for this is that when `gu = create :graph_user` then `gu.user.graph_user` does not equal `gu`.
    # Leads to strange and very annoying bugs.
    # Also, it is slower, since for every graph_user a user must be created.

    # If you need a graph_user with a user, make a user and use `user.graph_user`.
  end

  sequence :site_url do |n|
    "http://example.org/#{n}.html"
  end

  factory :comment do
  end

  factory :sub_comment do
  end

  factory :job do
  end

  sequence :title do |n|
    "Title #{n}"
  end

  factory :activity do
  end
end
