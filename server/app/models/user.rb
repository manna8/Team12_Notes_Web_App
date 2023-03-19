class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  #field :role, type: String


  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, if: -> { new_record? || !password.nil? }#, length: {in: 6..20 }, :on =>:create
  # uniqueness: true,
  has_secure_password

  def self.from_token_payload(payload)
    find(payload['sub'])
  end
end

