require 'rails_helper'


RSpec.describe NotesCollection, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      collection = build(:notes_collection)
      expect(collection).to be_valid
    end

    it "is not valid without a title" do
      collection = build(:notes_collection, title: nil)
      expect(collection).not_to be_valid
    end

    it "is not valid without a user" do
      collection = build(:notes_collection, user: nil)
      expect(collection).not_to be_valid
    end

  end

end