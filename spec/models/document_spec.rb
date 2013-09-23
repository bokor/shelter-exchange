require 'spec_helper'

describe Document do

  it_should_behave_like Uploadable

  it "sets the original name" do
    file = File.open("#{Rails.root}/spec/data/documents/testing.pdf")
    document = Document.gen(:document => file)
    document.original_name.should == "testing.pdf"
  end

  it "validates the max number of documents for an attachable" do
    note = Note.new
    Document.gen(:attachable => note)
    Document.gen(:attachable => note)
    Document.gen(:attachable => note)
    Document.gen(:attachable => note)

    document = Document.gen(:attachable => note)
    document.should have(1).error
    document.errors[:base].should == ["Max number of files exceeded"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe Document, "::MAX_TOTAL" do

  it "returns the default max total of documents" do
    Document::MAX_TOTAL.should == 4
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

    document1.attachable.should == note
    document1.attachable.should be_instance_of(Note)

    document2.attachable.should == animal
    document2.attachable.should be_instance_of(Animal)
  end
end

describe Document, "#attachable?" do

  it "returns true if the document has an attachable association" do
    animal  = Animal.new
    document1 = Document.new :attachable => animal
    document2 = Document.new

    document1.attachable?.should == true
    document2.attachable?.should == false
  end
end

