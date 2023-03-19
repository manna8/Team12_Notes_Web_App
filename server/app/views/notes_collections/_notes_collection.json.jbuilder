json.extract! notes_collection, :id, :title, :description, :created_at, :updated_at
json.url notes_collection_url(notes_collection, format: :json)
