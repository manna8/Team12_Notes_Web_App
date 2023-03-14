json.extract! note, :id, :title, :description, :owner_id, :collection, :image, :created_at, :updated_at
json.url note_url(note, format: :json)
