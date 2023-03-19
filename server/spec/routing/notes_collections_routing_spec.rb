require "rails_helper"

RSpec.describe NotesCollectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/notes_collections").to route_to("notes_collections#index")
    end

    it "routes to #show" do
      expect(get: "/notes_collections/1").to route_to("notes_collections#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/notes_collections").to route_to("notes_collections#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/notes_collections/1").to route_to("notes_collections#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/notes_collections/1").to route_to("notes_collections#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/notes_collections/1").to route_to("notes_collections#destroy", id: "1")
    end
  end
end
