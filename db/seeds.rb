user1 = User.create(email: "dita.landovska@gmail.com", role: 2, name: "Tomáš", surname: "Landovský", sex: nil, dob: nil, birth_year: nil, password_digest: "$2a$10$AzdiF2IFff1xxRtmIvbWcOKeDD8PNf.gA1rDc7GNF1uqE9J.VhOIm")

user = User.create(email: "landovsky@gmail.com", role: 2, name: "Tomáš", surname: "Landovský", sex: nil, dob: nil, birth_year: nil, password_digest: "$2a$10$ruQct.vUHXg562ZLn7Kvce2bdqfh7sEVOQX4ZGjJ3PIsfgF1opQIS")

list = List.create(user_id: user.id, occasion: "svatba příklad", occasion_of: "Tom & Dita")
list.donors << user1

Gift.create(list_id: list.id, user_id: nil, name: "zabraný dárek", description: "20 kusů krásných štíhlých kořenek", price_range: "max 350 Kč")

Gift.create(list_id: list.id, user_id: nil, name: "něco sladkého", description: "třeba z cukrárny", price_range: "350..450 Kč")
