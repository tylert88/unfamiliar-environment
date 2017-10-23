class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :github_username, :role
end
