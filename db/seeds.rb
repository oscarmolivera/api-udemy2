user = User.create(
  login: 'SeedUser01',
  name: 'seeding user',
  url: 'http://seeding-url.com',
  avatar_url: 'http://gravitar.com/seeding-user',
  provider: 'Github',
  encrypted_password: '$2a$12$JCgkfczW74t5DadlSCP9U.s0BGOrCAF8RS7UGOLyOMbY/NtDcoPfW' #user_pwd
)
(1..25).each_with_index do |article, index|
  Article.create!(
    {
      'title' => "TITULO Articulo N°#{index + 1}",
      'content' => "Contenido #{index + 1}: Lorem Ipsum ...",
      'slug' => "page-articulo-#{index + 1}",
      'user_id' => user.id
    }
  )
end
puts '25 Articulos creados!'
