require 'rails_helper'

describe DataExport::NotePresenter do

  before do
    @note = Note.gen
  end

  describe "#id" do
    it "returns the note id" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.id).to eq(@note.id)
    end
  end

  describe "#title" do
    it "returns the note details" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.title).to eq(@note.title)
    end
  end

  describe "#description" do
    it "returns the description details" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.description).to eq(@note.description)
    end
  end

  describe "#category" do
    it "returns the category details" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.category).to eq("General")
    end
  end

  describe "#hidden" do
    it "returns yes when the note has been hidden" do
      @note.update_column(:hidden, true)
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.hidden).to eq("Yes")
    end

    it "returns no when the note has not been hidden" do
      @note.update_column(:hidden, false)
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.hidden).to eq("No")
    end
  end

  describe "#animal_id" do
    it "returns empty when an animal is not attached to the note" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.animal_id).to be_nil
    end
  end

  context "with animal attached" do
    before do
      @animal = Animal.gen
      @note.notable = @animal
      @note.save!
    end

    describe "#animal_id" do
      it "returns the id of the animal attached to the note" do
        presenter = DataExport::NotePresenter.new(@note)
        expect(presenter.animal_id).to eq(@animal.id)
      end
    end
  end

  describe "#contact_id" do
    it "returns empty when a contact is not attached to the note" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.contact_id).to be_nil
    end
  end

  context "with contact attached" do
    before do
      @contact = Contact.gen
      @note.notable = @contact
      @note.save!
    end

    describe "#contact_id" do
      it "returns the id of the contact attached to the note" do
        presenter = DataExport::NotePresenter.new(@note)
        expect(presenter.contact_id).to eq(@contact.id)
      end
    end
  end

  context "with documents attached" do

    before do
      file1 = File.open("#{Rails.root}/spec/data/documents/testing.pdf")
      file2 = File.open("#{Rails.root}/spec/data/documents/testing.docx")
      file3 = File.open("#{Rails.root}/spec/data/images/adoption_contract.jpg")
      file4 = File.open("#{Rails.root}/spec/data/images/another_photo.jpg")

      Document.gen :attachable => @note, :document => file1
      Document.gen :attachable => @note, :document => file2
      Document.gen :attachable => @note, :document => file3
      Document.gen :attachable => @note, :document => file4
    end

    describe "#document1" do
      it "returns the first document attached to the note" do
        presenter = DataExport::NotePresenter.new(@note)
        expect(presenter.document1).to eq("documents/testing.pdf")
      end
    end

    describe "#document2" do
      it "returns the second document attached to the note" do
        presenter = DataExport::NotePresenter.new(@note)
        expect(presenter.document2).to eq("documents/testing.docx")
      end
    end

    describe "#document3" do
      it "returns the third document attached to the note" do
        presenter = DataExport::NotePresenter.new(@note)
        expect(presenter.document3).to eq("documents/adoption_contract.jpg")
      end
    end

    describe "#document4" do
      it "returns the forth document attached to the note" do
        presenter = DataExport::NotePresenter.new(@note)
        expect(presenter.document4).to eq("documents/another_photo.jpg")
      end
    end
  end

  describe "#create_at" do
    it "returns the note created_at timestamp" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.created_at).to eq(@note.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the note updated_at timestamp" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.updated_at).to eq(@note.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the note in a csv row format" do
      presenter = DataExport::NotePresenter.new(@note)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.title,
        presenter.description,
        presenter.category,
        presenter.hidden,
        presenter.animal_id,
        presenter.contact_id,
        presenter.document1,
        presenter.document2,
        presenter.document3,
        presenter.document4,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::NotePresenter.csv_header

      ).to eq([
        "Id",
        "Title",
        "Description",
        "Category",
        "Private",
        "Animal Id",
        "Contact Id",
        "Document 1",
        "Document 2",
        "Document 3",
        "Document 4",
        "Created At",
        "Updated At"
      ])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      note1 = Note.gen
      note2 = Note.gen
      csv = []

      DataExport::NotePresenter.as_csv([note1,note2], csv)

      expect(csv).to match_array([
        DataExport::NotePresenter.csv_header,
        DataExport::NotePresenter.new(note1).to_csv,
        DataExport::NotePresenter.new(note2).to_csv
      ])
    end
  end
end


