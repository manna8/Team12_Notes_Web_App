require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      note = build(:note)
      expect(note).to be_valid
    end
    it "is not valid without a title" do
      note = build(:note, title: nil)
      expect(note).not_to be_valid
    end

    it "is not valid without a user" do
      note = build(:note, user: nil)
      expect(note).not_to be_valid
    end
  end


end
