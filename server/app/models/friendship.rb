class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, type: String
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'


  after_save :update_friend_ids

  def update_friend_ids
    if self.status == 'accepted'
      self.sender.push(friend_ids: self.receiver.id) unless self.sender.friend_ids.include?(self.receiver.id)
      self.receiver.push(friend_ids: self.sender.id) unless self.receiver.friend_ids.include?(self.sender.id)
    end
  end
end
