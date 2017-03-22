Gift.create!([
  {list_id: 27, user_id: nil, name: "zabraný dárek", description: "20 kusů krásných štíhlých kořenek", price_range: "max 350 Kč"},
  {list_id: 27, user_id: nil, name: "něco sladkého", description: "třeba z cukrárny", price_range: "350..450 Kč"}
])
InvitationList.create!([
  {user_id: 3, list_id: 4},
  {user_id: 1, list_id: 13},
  {user_id: 1, list_id: 17},
  {user_id: 1, list_id: 18}
])
List.create!([
  {user_id: 1, occasion: "svatba priklad", occasion_of: "Tom & Dita"}
])
User.create!([
  {email: "landovsky@gmail.com", role: "registered", name: "Tomáš", surname: "Landovský", sex: nil, dob: nil, birth_year: nil, password_digest: "$2a$10$ruQct.vUHXg562ZLn7Kvce2bdqfh7sEVOQX4ZGjJ3PIsfgF1opQIS"}
])
