class User < ApplicationRecord
  enum role: { member: 1, admin: 2, editor: 3, judge: 4, superAdmin: 5 }
  belongs_to :member, dependent: :destroy
  has_secure_password

  def self.decode_jwt(token)
    secret_key = Rails.application.secret_key_base
    decoded_token = JWT.decode(token, secret_key, true, algorithm: 'HS256')
    user_id = decoded_token[0]['user_id']
    User.find_by(id: user_id)
    rescue JWT::DecodeError => e
    puts "JWT Decode Error: #{e.message}"
    nil
  end

  def generate_jwt
    payload = { user_id: id }
    secret_key = Rails.application.secret_key_base
    JWT.encode(payload, secret_key, 'HS256')
  end

  def authenticate(password)
    return false unless self.encrypted_password.present?
    BCrypt::Password.new(self.encrypted_password).is_password?(password)
  end

end
