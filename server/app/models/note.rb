class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :owner_id, type: String
  field :collection_id, type: String
  field :image, type: String

  belongs_to :user
  belongs_to :notes_collection, optional: true
end
