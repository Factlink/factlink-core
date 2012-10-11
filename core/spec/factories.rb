FactoryGirl.define do
  sequence :email do |n|
    "johndoe#{n}@example.com"
  end

  sequence :username do |n|
    "johndoe#{n}"
  end

  factory :user do
    username
    email
    password '123hoi'
    password_confirmation '123hoi'
    agrees_tos true

    trait :approved do
      approved true
    end

    trait :confirmed do
      confirmed_at DateTime.now
    end

    trait :admin do
      approved
      confirmed
      admin true
    end

    factory :approved_user, traits: [:approved]
    factory :confirmed_user, traits: [:confirmed]
    factory :approved_confirmed_user, traits: [:approved, :confirmed]
    factory :admin_user, traits: [:admin]
  end

  sequence :displaystring do |n|
    "Fact #{n}"
  end

  factory :fact_data do
    displaystring
  end

  factory :basefact do
    association :created_by, :factory => :graph_user
  end

  factory :fact do
    association :data, :factory => :fact_data
    association :created_by, :factory => :graph_user
    association :site
  end

  factory :graph_user do
  end

  sequence :url do |n|
    "http://example.org/#{n}.html"
  end

  factory :site do
    url
  end

  factory :fact_relation do
    association :created_by, :factory => :graph_user
  end

  sequence :title do |n|
    "Title #{n}"
  end

  factory :channel do
    association :created_by, :factory => :graph_user
    title
  end

  factory :job do
  end

  factory :topic do
    slug_title
  end
  sequence :slug_title do |n|
    "slug-#{n}-title"
  end

  factory :activity do
  end

  sequence :content do |n|
    "Content #{n}"
  end

  factory :message do
    content
  end

  factory :conversation do
  end
end
