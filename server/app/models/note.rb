class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :owner_id, type: String
  field :collection, type: String
  field :image, type: String
end
