class AccessCode
  include MongoMapper::Document

  belongs_to :client
  belongs_to :user
  key :value, :null => false

  def generate_token!
    access_token, expiration = user.generate_token!(client)
    return [access_token, expiration]
  end
end
