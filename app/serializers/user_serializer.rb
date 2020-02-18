class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :login, :name, :url, :avatar_url, :provider
end
