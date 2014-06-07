FactoryGirl.define do
  factory :user do
    name                  "Gryzelda Ciołek"
    email                 "mietekbylzajety@o2.pl"
    password              "ala123"
    password_confirmation "ala123"
    
    factory :edited_user do
      name  'Ala'
      email 'ala@ma.kota'
    end
  end
end
