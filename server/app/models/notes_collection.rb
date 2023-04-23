class NotesCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :shared_with, type: Array, default: []

  belongs_to :user
  has_many :note
end
