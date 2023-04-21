class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :photo_url, type: String
  belongs_to :user
  belongs_to :notes_collection, optional: true
end
