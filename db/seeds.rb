# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create User
user1 = User.create(email: "mark.j@yopmail.com", password: "Password@123")
user2 = User.create(email: "jenis@yopmail.com", password: "Password@123")

address = Address.create(address_line: "Belandur", city: "Bengaluru", state: "Karnataka", zip_code: "560103", country: "India", user_id: user1.id, is_primary: true)
address = Address.create(address_line: "Ranip", city: "Ahmedabad", state: "Gujarat", zip_code: "382480", country: "India", user_id: user2.id, is_primary: true)
