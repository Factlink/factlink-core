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

    trait :set_up do
      set_up true
    end

    trait :seen_the_tour do
      seen_tour_step 'tour_done'
    end

    trait :admin do
      admin true
    end

    factory :full_user, traits: [
      :set_up,
      :seen_the_tour
    ]
  end

  factory :social_account do
    trait :twitter do
      provider_name 'twitter'
      omniauth_obj(
        'uid' => 'some_twitter_uid',
        'provider' => 'twitter',
        'credentials' => {'token' => 'token', 'secret' => 'secret'},
        'info' => {'name' => 'Some Twitter Name'},
      )
    end

    trait :facebook do
      provider_name 'facebook'
      omniauth_obj(
        'uid' => 'some_facebook_uid',
        'provider' => 'facebook',
        'credentials' => {'token' => 'token', 'expires_at' => (DateTime.now + 4.weeks).to_i, 'expires' => true},
        'info' => {'name' => 'Some Facebook Name'},
      )
    end
  end

  sequence :displaystring do |n|
    "Fact #{n}"
  end

  factory :fact_data do
    displaystring
    sequence(:title) { |n| "Fact title #{n}" }
  end

  factory :fact do
    association :data, :factory => :fact_data
    association :site
  end

  factory :graph_user do
    # Never add an association with user here, it *does not work*, and *isnt desired*!
    # The reason for this is that when `gu = create :graph_user` then `gu.user.graph_user` does not equal `gu`.
    # Leads to strange and very annoying bugs.
    # Also, it is slower, since for every graph_user a user must be created.

    # If you need a graph_user with a user, make a user and use `user.graph_user`.
  end

  sequence :url do |n|
    "http://example.org/#{n}.html"
  end

  factory :site do
    url
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
