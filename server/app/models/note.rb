class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :photo, type: String
  field :shared_with, type: Array, default: []
  belongs_to :user
  belongs_to :notes_collection, optional: true

  field :shared_with, type: Array, default: []


  validates :title, presence: true
end
