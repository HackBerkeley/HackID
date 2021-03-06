class User
  include MongoMapper::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
    :recoverable, :rememberable, :trackable, :validatable

  key :username, String

  ## Database authenticatable
  key :email, String, :null => false, :default => ""
  key :unconfirmed_email, String
  key :encrypted_password, String, :null => false, :default => ""

  ## Recoverable
  key :reset_password_token,    String
  key :reset_password_sent_at,  Time

  ## Rememberable
  key :remember_created_at,  Time

  ## Trackable
  key :sign_in_count, Integer, :default => 0
  key :current_sign_in_at, Time
  key :last_sign_in_at,     Time
  key :current_sign_in_ip,  String
  key :last_sign_in_ip,     String

  ## Confirmable
  key :confirmation_token, String
  key :confirmed_at, Time
  key :confirmation_sent_at, Time

  ## Lockable
  key :failed_attempts, Integer, :default => 0
  key :locked_at, Time
  key :unlock_token, String

  key :access_tokens, Array

  def generate_token!(client)
    existing_token = self.access_tokens.find do |access_token|
      (access_token["client_id"] == client._id) && (access_token["expiration_time"] > (Time.now + 2.hours))
    end
    return [existing_token["value"], existing_token["expiration_time"]] if existing_token
    token = SecureRandom.urlsafe_base64(64)
    expiration_time = Time.now + 2.weeks
    self.access_tokens << {
      "value" => token,
      "expiration_time" => expiration_time,
      "client_id" => client._id
    }
    self.save && [token, expiration_time]
  end

  attr_accessor :sign_up_code

  validate :community_member?

  def community_member?
    unless self.persisted? or (sign_up_code == ENV["SIGN_UP_CODE"])
      errors.add( :sign_up_code, "You did not input a valid sign up code.")
    end
  end

  def develop_app(name, base_uri, publicly_accessible = false)
    Client.create(:name => name, :base_uri => base_uri, :owner => self, :publicly_accessible => publicly_accessible)
  end

end
