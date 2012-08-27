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

  def generate_token!
    token = SecureRandom.urlsafe_base64(64)
    expiration_time = Time.now + 2.weeks
    self.access_tokens << {
      "value" => token,
      "expiration_time" => expiration_time
    }
    self.save && [token, expiration_time]
  end

end
