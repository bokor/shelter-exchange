require "spec_helper"

describe Note do

  it "should have a default scope" do
    Note.scoped.to_sql.should == Note.order('notes.created_at DESC').to_sql
  end

  it "should require presence of title" do
    note = Note.new :title => nil
    note.should have(1).error_on(:title)
    note.errors[:title].should == ["cannot be blank"]
  end

  it "should require inclusion of category" do
    note = Note.new :category => "#{Note::CATEGORIES[0]} blah"
    note.should have(1).error_on(:category)
    note.errors[:category].should == ["needs to be selected"]
  end
end

describe Note, "::DEFAULT_CATEGORY" do
  it "should contain a single value for the default category" do
    Note::DEFAULT_CATEGORY.should == "general"
  end
end

describe Note, "::CATEGORIES" do
  it "should contain a default list of Categories" do
    Note::CATEGORIES.should == [
      "general", "medical", "behavioral", "intake"
    ]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Note, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    note = Note.new :shelter => shelter

    note.shelter.should == shelter
  end

  it "should return a readonly shelter" do
    note = Note.gen
    note.reload.shelter.should be_readonly
  end
end

describe Note, "#notable" do

  it "should belong to a notable object" do
    item   = Item.new
    animal = Animal.new
    note1  = Note.new :notable => item
    note2  = Note.new :notable => animal

    note1.notable.should == item
    note1.notable.should be_instance_of(Item)

    note2.notable.should == animal
    note2.notable.should be_instance_of(Animal)
  end
end

describe Note, "#documents" do

  before do
    @note = Note.gen

    @document1 = Document.gen \
      :attachable => @note,
      :document   => File.open("#{Rails.root}/spec/data/documents/document_1.csv")
    @document2 = Document.gen \
      :attachable => @note,
      :document   => File.open("#{Rails.root}/spec/data/documents/document_2.csv")
  end

  it "should have many documents" do
    @note.documents.count.should == 2
    @note.documents.should       =~ [@document1, @document2]
  end

  it "should destroy the documents when a note is deleted" do
    Document.count.should == 2
    @note.destroy
    Document.count.should == 0
  end
end

describe Note, "#notable?" do

  it "should validate if the note has an notable association" do
    item  = Item.new
    note1 = Note.new :notable => item
    note2 = Note.new

    note1.notable?.should == true
    note2.notable?.should == false
  end
end

