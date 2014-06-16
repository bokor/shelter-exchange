require "spec_helper"

describe PetfinderJob do

  before do
    Timecop.freeze(Time.parse("Mon, 12 May 2014"))

    @shelter = Shelter.gen
    Account.gen(:shelters => [@shelter])

    @available_for_adoption = Animal.gen \
      :animal_status_id => AnimalStatus::STATUSES[:available_for_adoption],
      :shelter => @shelter
    @adoption_pending = Animal.gen \
      :animal_status_id => AnimalStatus::STATUSES[:adoption_pending],
      :shelter => @shelter
    @adopted = Animal.gen \
      :animal_status_id => AnimalStatus::STATUSES[:adopted],
      :shelter => @shelter

    # Mock FTP Connection and Enqueue
    allow(Net::FTP).to receive(:open).and_return(true)
    @integration = Integration.gen \
      :petfinder,
      :username => "username",
      :password => "password",
      :shelter => @shelter
  end

  describe "#initialize" do

    it "assigns @start_time" do
      job = PetfinderJob.new(@shelter.id)
      expect(job.instance_variable_get(:@start_time)).to eq(Time.now)
    end

    it "assigns @shelter" do
      job = PetfinderJob.new(@shelter.id)
      expect(job.instance_variable_get(:@shelter)).to eq(@shelter)
    end

    it "assigns @integration" do
      job = PetfinderJob.new(@shelter.id)
      expect(job.instance_variable_get(:@integration)).to eq(@integration)
    end
  end

  describe "#perform" do

    context "with successful ftp connection" do

      before do
        stub_const("Integration::Petfinder::FTP_URL", "127.0.0.1")
        stub_const("Net::FTP::FTP_PORT", "21212")
        @ftp_server = FakeFtp::Server.new(21212, 21213)
        @ftp_server.start
      end

      after do
        @ftp_server.stop
      end

      it "connection to ftp server" do
        ftp = double(Net::FTP).as_null_object
        expect(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:login).with(@integration.username, @integration.password)
        PetfinderJob.new(@shelter.id).perform
      end

      it "created a temp directory for csv file per shelter" do
        temp_dir = Rails.root.join("tmp/petfinder/#{@shelter.id}")
        PetfinderJob.new(@shelter.id).perform
        expect(temp_dir).to exist
      end

      it "assigns @animals" do
        job = PetfinderJob.new(@shelter.id)
        job.perform

        expect(
          job.instance_variable_get(:@animals)
        ).to match_array([
          @available_for_adoption, @adoption_pending
        ])
      end

      it "change directory for the csv file" do
        ftp = double(Net::FTP).as_null_object
        expect(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:chdir).with("import")
        PetfinderJob.new(@shelter.id).perform
      end

      it "creates and uploads CSV file" do
        filepath = File.join(Rails.root, "tmp", "petfinder", "#{@shelter.id}", "#{@integration.username}.csv")
        allow(CSV).to receive(:open).with(filepath, "w+:UTF-8").and_call_original

        PetfinderJob.new(@shelter.id).perform

        file = @ftp_server.file("#{@integration.username}.csv")
        row1 = Integration::PetfinderPresenter.new(@available_for_adoption).to_csv
        row2 = Integration::PetfinderPresenter.new(@adoption_pending).to_csv

        expect(file).to be_passive
        expect(CSV.parse(file.data)).to match_array([
          Integration::PetfinderPresenter.csv_header,
          row1.map{|r| r.to_s unless r.nil? },
          row2.map{|r| r.to_s unless r.nil? }
        ])
      end

      it "change directory for photos" do
        ftp = double(Net::FTP).as_null_object
        expect(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:chdir).with("photos")
        PetfinderJob.new(@shelter.id).perform
      end

      it "sends photo files to ftp server" do
        allow_any_instance_of(Photo).to receive(:guid).and_return("1234abcd")

        Photo.gen \
          :attachable => @available_for_adoption,
          :image => File.open("#{Rails.root}/spec/data/images/photo.jpg")
        Photo.gen \
          :attachable => @adoption_pending,
          :image => File.open("#{Rails.root}/spec/data/images/adoption_contract.jpg")

        stub_request(
          :get,
          "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@available_for_adoption.id}/large/1234abcd.jpg"
        ).to_return(:body => File.binread("#{Rails.root}/spec/data/images/photo.jpg"))

        stub_request(
          :get,
          "https://shelterexchange-test.s3.amazonaws.com/animals/photos/#{@adoption_pending.id}/large/1234abcd.jpg"
        ).to_return(:body => File.binread("#{Rails.root}/spec/data/images/adoption_contract.jpg"))

        PetfinderJob.new(@shelter.id).perform

        expect(@ftp_server.files).to include(
          "#{@available_for_adoption.id}-1.jpg"
        )
        expect(@ftp_server.files).to include(
          "#{@adoption_pending.id}-1.jpg"
        )
      end

      it "ftp storbinary for photo upload" do
        Photo.gen \
          :attachable => @available_for_adoption,
          :image => File.open("#{Rails.root}/spec/data/images/photo.jpg")

        ftp = double(Net::FTP).as_null_object
        allow(Net::FTP).to receive(:new).and_return(ftp)
        allow(Net::HTTP).to receive(:get).and_return("image_url")

        stringio_photo = StringIO.new(File.binread("#{Rails.root}/spec/data/images/photo.jpg"))
        allow(StringIO).to receive(:new).and_return(stringio_photo)

        expect(ftp).to receive(:storbinary).with("STOR #{@available_for_adoption.id}-1.jpg", stringio_photo, 1024)
        PetfinderJob.new(@shelter.id).perform
      end

      it "closes ftp connection" do
        expect_any_instance_of(Net::FTP).to receive(:close)
        PetfinderJob.new(@shelter.id).perform
      end

      it "logs message when finished" do
        expect(PetfinderJob.logger).to receive(:info).with("#{@shelter.id} :: #{@shelter.name} :: finished in 0.0")
        PetfinderJob.new(@shelter.id).perform
      end
    end

    context "with error ftp authentication" do

      before do
        ftp = double("Net::FTP").as_null_object
        allow(Net::FTP).to receive(:new).and_return(ftp)
        allow(ftp).to receive(:last_response_code).and_return("530")
        allow(ftp).to receive(:login).and_raise(Net::FTPPermError.new("530 Login Error"))
      end

      it "sends revoked_integration email" do
        expect(OwnerMailer).to receive(:revoked_integration).with(@integration)
        PetfinderJob.new(@shelter.id).perform
      end

      it "sends revoked email" do
        expect(IntegrationMailer).to receive(:revoked).with(@integration)
        PetfinderJob.new(@shelter.id).perform
      end

      it "revokes integration access (deletes from db)" do
        expect {
          PetfinderJob.new(@shelter.id).perform
        }.to change(Integration, :count).by(-1)
        expect(
          Integration.where(:id => @integration.id)
        ).to be_empty
      end

      it "logs message when failure" do
        expect(PetfinderJob.logger).to receive(:error).
          with("#{@shelter.id} :: #{@shelter.name} :: failed :: 530 Login Error")
        PetfinderJob.new(@shelter.id).perform
      end
    end
  end

  describe ".logger" do
    it "returns a logger" do
      logger = PetfinderJob.logger
      expect(logger).to be_instance_of(Logger)
      expect(Logger.respond_to?(:filename)).to be_false
    end
  end
end

