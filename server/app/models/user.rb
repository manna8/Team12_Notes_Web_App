class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :role, type: String, default: 'user'
  field :friend_ids, type: Array, default: []

  has_many :shared_notes, class_name: 'Note'
  has_many :shared_collections, class_name: 'NotesCollection'

  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, if: -> { new_record? || !password.nil? }#, length: {in: 6..20 }, :on =>:create

  has_secure_password

end

