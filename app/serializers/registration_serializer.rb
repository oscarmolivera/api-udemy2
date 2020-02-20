class RegistrationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :login, :password
end
