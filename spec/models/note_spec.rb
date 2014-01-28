require "spec_helper"

describe Note do

  it "has a default scope" do
    expect(Note.scoped.to_sql).to eq(Note.order('notes.created_at DESC').to_sql)
  end

  it "requires presence of title" do
    note = Note.new :title => nil
    expect(note).to have(1).error_on(:title)
    expect(note.errors[:title]).to match_array(["cannot be blank"])
  end

  it "requires inclusion of category" do
    note = Note.new :category => "#{Note::CATEGORIES[0]} blah"
    expect(note).to have(1).error_on(:category)
    expect(note.errors[:category]).to match_array(["needs to be selected"])
  end
end

# Constants
#----------------------------------------------------------------------------
describe Note, "::DEFAULT_CATEGORY" do
  it "contains a single value for the default category" do
    expect(Note::DEFAULT_CATEGORY).to eq("general")
  end
end

describe Note, "::CATEGORIES" do
  it "contains a default list of Categories" do
    expect(Note::CATEGORIES).to match_array([
      "general", "medical", "behavioral", "intake"
    ])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Note, ".without_hidden" do

  it "returns notes that aren't hidden" do
    note1 = Note.gen
    note2 = Note.gen
    Note.gen :hidden => true

    notes = Note.without_hidden
    expect(notes).to match_array([note1, note2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Note, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    note = Note.new :shelter => shelter

    expect(note.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    note = Note.gen
    expect(note.reload.shelter).to be_readonly
  end
end

describe Note, "#notable" do

  it "belongs to a notable object" do
    item = Item.new
    animal = Animal.new
    note1 = Note.new :notable => item
    note2 = Note.new :notable => animal

    expect(note1.notable).to eq(item)
    expect(note1.notable).to be_instance_of(Item)

    expect(note2.notable).to eq(animal)
    expect(note2.notable).to be_instance_of(Animal)
  end
end

describe Note, "#documents" do

  before do
    @note = Note.gen
    @document1 = Document.gen \
      :attachable => @note,
      :document => File.open("#{Rails.root}/spec/data/documents/testing.pdf")
    @document2 = Document.gen \
      :attachable => @note,
      :document => File.open("#{Rails.root}/spec/data/documents/testing.docx")
  end

  it "has many documents" do
    expect(@note.documents.count).to eq(2)
    expect(@note.documents).to match_array([@document1, @document2])
  end

  it "destroys the documents when a note is deleted" do
    expect(Document.count).to eq(2)
    @note.destroy
    expect(Document.count).to eq(0)
  end
end

describe Note, "#notable?" do

  it "returns true if the note has an notable association" do
    item = Item.new
    note1 = Note.new :notable => item
    note2 = Note.new

    expect(note1.notable?).to eq(true)
    expect(note2.notable?).to eq(false)
  end
end

