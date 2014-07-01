FactoryGirl.define do
  factory :user do
    username "foo"
    password "foobar"
    password_confirmation { |u| u.password }
    email "foo@example.com"

    # Child of :user factory, since it's in the `factory :user` block
    factory :admin do
      admin true
    end
  end
end