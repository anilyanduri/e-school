FactoryBot.define do
  factory(:user) do
    first_name { Faker::Name::first_name }
    last_name { Faker::Name::last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    factory :admin do
      after(:create) {|user| user.add_role(:admin)}
    end
  end

  factory(:school) do
    created_by_id { 1 }
    description { "" }
    name { "Test school" }
    status { "A" }
  end

  factory(:course) do
    description { "ToFactory: RubyParser exception parsing this attribute" }
    material { "ToFactory: RubyParser exception parsing this attribute" }
    name { "Course 1" }
    school_id { 1 }
    status { true }
  end

  factory(:batch) do
    course_id { 1 }
    name { "ToFactory: RubyParser exception parsing this attribute" }
    school_id { 1 }
    status { true }
  end

  factory(:enrollment) do
    batch_id { 1 }
    progress { 26 }
    status { "approved" }
    user_id { 6 }
  end
end
