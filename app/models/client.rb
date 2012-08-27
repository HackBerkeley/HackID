class Client
  include MongoMapper::Document

  key :name, String
  key :base_uri, String
  key :client_secret, String
  key :access_keys, Array

  def allow_access_to_user(user)
    code = SecureRandom.hex(32)
    AccessCode.create(:value => code, :user => user, :client => self)
    code
  end
end
