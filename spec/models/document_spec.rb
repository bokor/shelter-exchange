require 'spec_helper'

describe Document do

  it_should_behave_like Uploadable

  it "sets the original name" do
    file = File.open("#{Rails.root}/spec/data/documents/testing.pdf")
    document = Document.gen(:document => file)
    expect(document.original_name).to eq("testing.pdf")
  end

  it "validates the max number of documents for an attachable" do
    note = Note.new
    Document.gen(:attachable => note)
    Document.gen(:attachable => note)
    Document.gen(:attachable => note)
    Document.gen(:attachable => note)

    document = Document.gen(:attachable => note)
    expect(document).to have(1).error
    expect(document.errors[:base]).to match_array(["Max number of files exceeded"])
  end
end

# Constants
#----------------------------------------------------------------------------
describe Document, "::MAX_TOTAL" do

  it "returns the default max total of documents" do
    expect(Document::MAX_TOTAL).to eq(4)
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Document, "#attachable" do

  it "belongs to a attachable object" do
    note = Note.new
    animal = Animal.new

    document1 = Document.new :attachable => note
    document2 = Document.new :attachable => animal

    expect(document1.attachable).to eq(note)
    expect(document1.attachable).to be_instance_of(Note)

    expect(document2.attachable).to eq(animal)
    expect(document2.attachable).to be_instance_of(Animal)
  end
end

describe Document, "#attachable?" do

  it "returns true if the document has an attachable association" do
    animal  = Animal.new
    document1 = Document.new :attachable => animal
    document2 = Document.new

    expect(document1.attachable?).to eq(true)
    expect(document2.attachable?).to eq(false)
  end
end

