class Client
  include MongoMapper::Document

  key :name, String
  key :base_uri, String
  key :publicly_accessible, Boolean, :default => false
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

  def self.curate_hot_apps
    # map reduce runs on access_code class
    map = <<-END
      function () {
        users = {};
        users[this.user_id] = true;
        emit(db.clients.findOne({"_id" : this.client_id}), { users : users, count : 1});
      }
    END
    reduce = <<-END
      function (client, values) {
        merged_users = {};
        for (var value in values) {
          for (var user in value.users) {
            if (value.users.hasOwnProperty(user)) {
              merged_users[user] = true;
            }
          }
        }
        var i = 0;
        for (var u in merged_users) { i++; }
        return { users : merged_users, count : i };
      }
    END
    AccessCode.collection.map_reduce(map, reduce, :out => { :reduce => "hot_clients" })
  end

end
