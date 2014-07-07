FactoryGirl.define do
  factory :user do
    username 'foobar'
    password 'foobar'
    email 'test_user@example.com'
  end

  factory :admin, class: User do
    username 'admin'
    password 'admin'
    email 'admin@example.com'
    admin true
  end
end