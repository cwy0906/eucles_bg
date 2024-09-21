class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true
    self.primary_key = :id_hash
    enum role: { root: 0, admin: 1, user: 2}

    def is_management?
      self.role_before_type_cast <= 1
    end


end
