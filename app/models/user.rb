# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :user_name, :session_token, presence: true, uniqueness: true 
    validates :password_digest, presence: true 
    validates :password, length: { minimum: 8 }, allow_nil: true 
    
    after_initialize :ensure_session_token 

    attr_reader :password
    
    
    def self.find_by_credentials(user_name, password) 
        user = self.find_by(user_name: user_name)
        return nil unless user && user.is_password?(password)
        user
    end 

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end

    def reset_session_token! 
        self.update!(session_token: User.generate_session_token)
        self.session_token
    end 

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        bcrypt_password = BCrypt::Password.new(self.password_digest)
        bcrypt_password.is_password?(password)
    end 


    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end 

end 
