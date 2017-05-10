if ["test","development"].include? Rails.env
  user1 = User.create(email: "dita.landovska@gmail.com", password: "test", role: 2, name: "Dita", surname: "Landovská", sex: nil, dob: nil, birth_year: nil, password_digest: "$2a$10$AzdiF2IFff1xxRtmIvbWcOKeDD8PNf.gA1rDc7GNF1uqE9J.VhOIm")
  user1.save

  user = User.create(email: "landovsky@gmail.com", role: 2, password: "test", name: "Tomáš", surname: "Landovský", sex: nil, dob: nil, birth_year: nil, password_digest: "$2a$10$ruQct.vUHXg562ZLn7Kvce2bdqfh7sEVOQX4ZGjJ3PIsfgF1opQIS")
  user.save

  list1 = List.create(user_id: user.id, occasion: 1, occasion_of: "Tom & Dita", occasion_date: 10.days.from_now, occasion_data: "dobry" )
  list1.save
  list1.invitees << user1
  
  list2 = List.create(user_id: user.id, occasion: 1, occasion_of: "Tom & Dita", occasion_date: 10.days.from_now, occasion_data: "neco" )
  list2.save
  list2.invitees << user

  Gift.create(list_id: list1.id, user_id: user1.id, name: "zabraný dárek", description: "20 kusů krásných štíhlých kořenek", price_range: "max 350 Kč")

  Gift.create(list_id: list1.id, user_id: user.id, name: "něco sladkého", description: "třeba z cukrárny", price_range: "350..450 Kč")
end
