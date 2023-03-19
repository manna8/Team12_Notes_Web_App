require 'rails_helper'

RSpec.describe NotesCollection, type: :model do
  describe "validations" do
    let(:user) { FactoryBot.create(:user) }

    it "is valid with valid attributes" do
      notes_collection = described_class.new(
        title: "Test note",
        description: "This is a test note",
        user: user
      )
      expect(notes_collection).to be_valid
    end

    it "is valid without a title" do
      notes_collection = described_class.new(
        description: "This is a test note",
        user: user
      )
      expect(notes_collection).to be_valid
    end

    it "is not valid without a user" do
      notes_collection = described_class.new(
        title: "Test note",
        description: "This is a test note",
        user: nil
      )
      expect(notes_collection).not_to be_valid
    end
  end

end
