class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true
    self.primary_key = :id_hash
    enum role: { root: 0, admin: 1, user: 2}

    def self.quick_create_dummy_user(arg = nil)
      arg     = (arg.present?) ? arg.to_s : (0...8).map { (65 + rand(26)).chr }.join
      id_hash = SecureRandom.hex(16)
      User.create( id: id_hash, email: "test#{arg}@email.com", user_name: "test_#{arg}", nickname: "nick_#{arg}", password: "pw_#{arg}", role: 2 )
    end

    def is_management?
      self.role_before_type_cast <= 1
    end

end
