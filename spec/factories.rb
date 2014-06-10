FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Ciołek the #{n.ordinalize}" }
    sequence(:email) { |n| "mietek_#{n}@o2.pl" }
    password "ala123"
    password_confirmation "ala123"
    
    factory :admin do
      admin true
    end
    
    factory :edited_user do
      name  'Ala'
      email 'ala@ma.kota'
    end
  end
  
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
