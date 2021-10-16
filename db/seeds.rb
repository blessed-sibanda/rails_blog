# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(email: "blessed@example.com",
                    password: "1234pass")

Post.create!(
  title: "Why Rails is Awesome",
  content: %Q{
  Enim eius quo, cumque dolorem reprehenderit deleniti maxime labore nulla hic in a? Neque quos nihil exercitationem, consequatur mollitia a ea ducimus. Commodi ullam quod esse perspiciatis praesentium ipsum minus magnam nostrum quidem modi fugit sunt iste nobis eum exercitationem delectus ex molestias, enim molestiae. Aut totam eligendi sed odit! Soluta voluptatum sapiente distinctio dolore expedita optio? Soluta repellendus officiis nostrum. Iusto odit velit repellat unde nemo, nulla soluta maiores aliquam inventore commodi deleniti natus blanditiis dolore ipsa iure ex fuga qui eum dolor! Minus possimus dolore quod ab tempore, reiciendis ratione.
  },
  tag_list: "Ruby, Rails, Web, Programming",
  author: user,
  status: "Published",
)

Post.create!(
  title: "React vs Angular vs Vue",
  content: %Q{
  Commodi ullam quod esse perspiciatis praesentium ipsum minus magnam nostrum quidem modi fugit sunt iste nobis eum exercitationem delectus ex molestias, enim molestiae. Aut totam eligendi sed odit! Soluta voluptatum sapiente distinctio dolore expedita optio? Enim eius quo, cumque dolorem reprehenderit deleniti maxime labore nulla hic in a? Soluta repellendus officiis nostrum. Iusto odit velit repellat unde nemo, nulla soluta maiores aliquam inventore commodi deleniti natus blanditiis dolore ipsa iure ex fuga qui eum dolor ratione.
  },
  tag_list: "React, Vue, Angular",
  author: user,
  status: "Published",
)
