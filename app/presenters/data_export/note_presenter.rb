class DataExport::NotePresenter < Presenter

  def initialize(note)
    @note = note
    @documents = @note.documents.all
  end

  def id
    @note.id
  end

  def title
    @note.title
  end

  def description
    @note.description
  end

  def category
    @note.category.humanize
  end

  def hidden
    @note.hidden? ? "Yes" : "No"
  end

  def animal_id
    @note.notable_id if @note.notable? && @note.notable_type == "Animal"
  end

  def contact_id
    @note.notable_id if @note.notable? && @note.notable_type == "Contact"
  end

  def document1
    "documents/#{@documents[0].original_name}" if @documents && @documents[0]
  end

  def document2
    "documents/#{@documents[1].original_name}" if @documents && @documents[1]
  end

  def document3
    "documents/#{@documents[2].original_name}" if @documents && @documents[2]
  end

  def document4
    "documents/#{@documents[3].original_name}" if @documents && @documents[3]
  end

  def created_at
    @note.created_at
  end

  def updated_at
    @note.updated_at
  end

  def to_csv
    [
      id,
      title,
      description,
      category,
      hidden,
      animal_id,
      contact_id,
      document1,
      document2,
      document3,
      document4,
      created_at,
      updated_at
    ]
  end

  # Class Methods
  #----------------------------------------------------------------------------
  def self.csv_header
    [
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
    ]
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end
end


