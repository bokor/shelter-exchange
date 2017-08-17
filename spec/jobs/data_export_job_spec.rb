require "rails_helper"

describe DataExportJob do

  before do
    Timecop.freeze(Time.parse("Mon, 12 May 2014"))
    @owner = User.gen :email => "owner@example.com", :role => "owner"
    @admin = User.gen :email => "admin@example.com", :role => "admin"
    @user = User.gen :email => "user@example.com", :role => "user"
    @account = Account.gen :users => [@owner, @admin, @user]
    @shelter = Shelter.gen \
      :account_id => @account.id,
      :name => "Mailer Test Shelter"
  end

  describe "#initialize" do

    it "assigns @start_time" do
      job = DataExportJob.new(@shelter.id)
      expect(job.instance_variable_get(:@start_time)).to eq(Time.now)
    end

    it "assigns @shelter" do
      job = DataExportJob.new(@shelter.id)
      expect(job.instance_variable_get(:@shelter)).to eq(@shelter)
    end
  end

  describe "#perform" do

    before do
      @base_dir = File.join(Rails.root, "tmp", "data_export")
      @temp_dir = File.join(@base_dir, "#{@shelter.id}")
      allow(FileUtils).to receive(:rm_rf).and_return(true)
    end

    after do
      allow(FileUtils).to receive(:rm_rf).and_call_original
      FileUtils.rm_rf Dir.glob("#{@base_dir}/*")
    end

    it "creates temp directories for csv file per shelter" do
      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "photos"))
      expect(File).to exist(File.join(@temp_dir, "documents"))
    end

    it "does not create csv files for empty db tables" do
      DataExportJob.new(@shelter.id).perform

      expect(File).not_to exist(File.join(@temp_dir, "accommodations.csv"))
      expect(File).not_to exist(File.join(@temp_dir, "animals.csv"))
      expect(File).not_to exist(File.join(@temp_dir, "contacts.csv"))
      expect(File).not_to exist(File.join(@temp_dir, "notes.csv"))
      expect(File).not_to exist(File.join(@temp_dir, "photos.csv"))
      expect(File).not_to exist(File.join(@temp_dir, "status_histories.csv"))
      expect(File).not_to exist(File.join(@temp_dir, "tasks.csv"))
      expect(File).not_to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an accomodations.csv file" do
      Accommodation.gen :shelter => @shelter
      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "accommodations.csv"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an animals.csv file" do
      Animal.gen :shelter => @shelter
      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "animals.csv"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an contacts.csv file" do
      Contact.gen :shelter => @shelter
      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "contacts.csv"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an notes.csv file and downloads attachment" do
      allow_any_instance_of(Document).to receive(:guid).and_return("1234abcd")

      file = File.open("#{Rails.root}/spec/data/documents/testing.pdf")
      note = Note.gen :shelter => @shelter
      document = Document.gen :attachable => note, :document => file

      stub_request(:get, "https://shelterexchange-test.s3.amazonaws.com/notes/documents/#{document.id}/original/1234abcd.pdf").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})

      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "notes.csv"))
      expect(File).to exist(File.join(@temp_dir, "documents", "testing.pdf"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an photos.csv file and downloads attachment" do
      allow_any_instance_of(Photo).to receive(:guid).and_return("1234abcd")

      file = File.open("#{Rails.root}/spec/data/images/photo.jpg")
      animal = Animal.gen :shelter => @shelter
      Photo.gen :image => file, :attachable => animal

      stub_request(:get, "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{animal.id}/original/1234abcd.jpg").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})

      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "photos.csv"))
      expect(File).to exist(File.join(@temp_dir, "photos", "photo.jpg"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an status_histories.csv file" do
      StatusHistory.gen :shelter => @shelter
      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "status_histories.csv"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "creates an tasks.csv file" do
      Task.gen :shelter => @shelter
      DataExportJob.new(@shelter.id).perform
      expect(File).to exist(File.join(@temp_dir, "tasks.csv"))
      expect(File).to exist(File.join(@base_dir, "#{@shelter.id}-#{@shelter.name.parameterize.dasherize}.zip"))
    end

    it "sends a completed email" do
      Animal.gen :shelter => @shelter
      DataExportJob.new(@shelter.id).perform

      expect(ActionMailer::Base.deliveries.last.subject).to eq("Mailer Test Shelter's export has completed!")
    end
  end

  describe ".logger" do
    it "returns a logger" do
      logger = DataExportJob.logger
      expect(logger).to be_instance_of(Logger)
      expect(Logger.respond_to?(:filename)).to be_falsey
    end
  end
end

