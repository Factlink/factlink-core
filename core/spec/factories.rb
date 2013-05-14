FactoryGirl.define do
  sequence :email do |n|
    "johndoe#{n}@example.com"
  end

  sequence :username do |n|
    "johndoe#{n}"
  end

  sequence :first_name do |n|
    "John#{n}"
  end

  sequence :last_name do |n|
    "Doe#{n}"
  end

  factory :user do
    username
    email
    first_name
    last_name
    password '123hoi'
    password_confirmation '123hoi'
    agrees_tos true

    trait :approved do
      approved true
    end

    trait :confirmed do
      confirmed_at DateTime.now
    end

    trait :seen_the_tour do
      seen_the_tour true
      seen_tour_step 'tour_done'
    end

    trait :admin do
      approved
      confirmed
      seen_the_tour
      admin true
    end

    trait :acting_as_non_signed_in do
      features [:act_as_non_signed_in]
    end

    factory :approved_user, traits: [:approved]
    factory :confirmed_user, traits: [:confirmed]
    factory :approved_confirmed_user, traits: [:approved, :confirmed]
    factory :active_user, traits: [:approved, :confirmed, :seen_the_tour]
    factory :admin_user, traits: [:admin]
    factory :acting_as_non_signed_in_user, traits: [:acting_as_non_signed_in, :approved, :confirmed, :seen_the_tour]
  end

  sequence :displaystring do |n|
    "Fact #{n}"
  end

  factory :fact_data do
    displaystring
    sequence(:title) {|n| "Fact title #{n}"}
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

  factory :fact_relation do
    association :fact
    association :from_fact, factory: :fact
    association :created_by, :factory => :graph_user
    type :supporting
  end

  factory :comment do
  end

  factory :sub_comment do
  end

  factory :channel do
    association :created_by, :factory => :graph_user
    sequence(:title) {|n| "Channel title #{n}"}
  end

  factory :job do
  end

  factory :topic do
    title
  end

  sequence :title do |n|
    "Title #{n}"
  end

  factory :activity do
  end

  sequence :content do |n|
    "Content #{n}"
  end

  factory :message do
    content
    association :sender, factory: :user
  end

  factory :conversation do
    after(:create) do |conversation, evaluator|
      fact = create(:fact)
      conversation.fact_data = fact.data
      conversation.save
    end

    factory :conversation_with_messages do
      ignore do
        message_count 3
        user_count 3
      end

      after(:create) do |conversation, evaluator|
        conversation.recipients = create_list(:user, evaluator.user_count)
        (1..evaluator.message_count).each do |i|
          # just use users #1, #2, #3, #1, #2, etc.
          sender = conversation.recipients[i%evaluator.user_count]
          create(:message, conversation: conversation, sender: sender)
        end
      end
    end
  end
end
