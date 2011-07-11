FactoryGirl.define do
  sequence :email do |n|
    "johndoe#{n}@example.com"
  end
  
  sequence :username do |n|
    "johndoe#{n}"
  end
  
  factory :user do
    # first_name 'John'
    # last_name  'Doe'
    username
    email 
    password '123hoi'
    password_confirmation '123hoi'
  end
  
  factory :fact do
    
  end
end