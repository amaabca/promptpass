FactoryGirl.define do
  factory :secret do
    body "test"
    encrypted_body "WERFLERS ER JERST PLERN FERNTERSTERC. TRER THERM!"
    association :recipient
  end
end
