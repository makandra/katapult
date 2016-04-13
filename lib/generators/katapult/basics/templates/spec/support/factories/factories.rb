FactoryGirl.define do

  factory :EXAMPLE do
    status 'pending'
    uuid { SecureRandom.uuid }
    sequence(:title) { |i| "Titel #{ i }"}
  end

end
