class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true

    self.primary_key = :id_hash
end
