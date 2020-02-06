FactoryBot.define do
  factory :user do
    sequence (:login) { |l| "usuario.prueba#{l}@email_acount.com" }
    name { "Usuario de Prueba" }
    url { "http://example-url.com" }
    avatar_url { "http://gravitar.com/oolivera" }
    provider { "Github" }
  end
end
