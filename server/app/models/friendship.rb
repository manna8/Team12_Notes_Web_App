class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  belongs_to :user, foreign_key: :sender_id, class_name: 'User'
  belongs_to :user, foreign_key: :receiver_id, class_name: 'User'


  validates :status, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
end
