# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Node.create(id: 130)
Node.create(id: 125, parent_id: 130)
Node.create(id: 2828230, parent_id: 125)
Node.create(id: 4430546, parent_id: 125)
Node.create(id: 5497637, parent_id: 4430546)
