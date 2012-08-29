class Client
  include MongoMapper::Document

  key :name, String
  key :base_uri, String
  key :client_secret, String
  key :access_keys, Array
  belongs_to :owner, :class => User

  before_save :set_client_secret

  def allow_access_to_user(user)
    code = SecureRandom.hex(32)
    AccessCode.create(:value => code, :user => user, :client => self)
    code
  end

  def set_client_secret
    self.client_secret ||= SecureRandom.hex(48)
  end
  private :set_client_secret

end
