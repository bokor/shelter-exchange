require "spec_helper"

describe AdoptAPetJob do

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
      :adopt_a_pet,
      :username => "username",
      :password => "password",
      :shelter => @shelter
  end

  describe "#initialize" do

    it "assigns @start_time" do
      job = AdoptAPetJob.new(@shelter.id)
      expect(job.instance_variable_get(:@start_time)).to eq(Time.now)
    end

    it "assigns @shelter" do
      job = AdoptAPetJob.new(@shelter.id)
      expect(job.instance_variable_get(:@shelter)).to eq(@shelter)
    end

    it "assigns @integration" do
      job = AdoptAPetJob.new(@shelter.id)
      expect(job.instance_variable_get(:@integration)).to eq(@integration)
    end
  end

  describe "#perform" do

    context "with successful ftp connection" do

      before do
        stub_const("Integration::AdoptAPet::FTP_URL", "127.0.0.1")
        stub_const("Net::FTP::FTP_PORT", "21212")
        @ftp_server = FakeFtp::Server.new(21212, 21213)
        @ftp_server.start
      end

      after do
        @ftp_server.stop
      end

      it "created a temp directory for csv file per shelter" do
        temp_dir = Rails.root.join("tmp/adopt_a_pet/#{@shelter.id}")
        AdoptAPetJob.new(@shelter.id).perform
        expect(temp_dir).to exist
      end

      it "assigns @animals" do
        job = AdoptAPetJob.new(@shelter.id)
        job.perform

        expect(
          job.instance_variable_get(:@animals)
        ).to match_array([
          @available_for_adoption, @adoption_pending
        ])
      end

      it "uploads import config" do
        AdoptAPetJob.new(@shelter.id).perform

        import_cfg_file = @ftp_server.file('import.cfg')
        expect(import_cfg_file.bytes).to eq(10691)
        expect(import_cfg_file).to be_passive
      end

      it "creates and uploads CSV file" do
        filepath = File.join(Rails.root, "tmp", "adopt_a_pet", "#{@shelter.id}", "pets.csv")
        allow(CSV).to receive(:open).with(filepath, "w+:UTF-8").and_call_original

        AdoptAPetJob.new(@shelter.id).perform

        file = @ftp_server.file('pets.csv')
        row1 = Integration::AdoptAPetPresenter.new(@available_for_adoption).to_csv
        row2 = Integration::AdoptAPetPresenter.new(@adoption_pending).to_csv

        expect(file).to be_passive
        expect(CSV.parse(file.data)).to match_array([
          Integration::AdoptAPetPresenter.csv_header,
          row1.map{|r| r.to_s unless r.nil? },
          row2.map{|r| r.to_s unless r.nil? }
        ])
      end

      it "closes ftp connection" do
        expect_any_instance_of(Net::FTP).to receive(:close)
        AdoptAPetJob.new(@shelter.id).perform
      end

      it "logs message when finished" do
        expect(AdoptAPetJob.logger).to receive(:info).with("#{@shelter.id} :: #{@shelter.name} :: finished in 0.0")
        AdoptAPetJob.new(@shelter.id).perform
      end
    end

    context "with error ftp authentication" do

      before do
        @integration.update_column(:username, "incorrect_username")
      end

      it "sends notify_se_owner email" do
        IntegrationMailer.stub(:delay => IntegrationMailer)
        expect(IntegrationMailer).to receive(:notify_se_owner).with(@integration)
        AdoptAPetJob.new(@shelter.id).perform
      end

      it "sends revoked_notification email" do
        IntegrationMailer.stub(:delay => IntegrationMailer)
        expect(IntegrationMailer).to receive(:revoked_notification).with(@integration)
        AdoptAPetJob.new(@shelter.id).perform
      end

      it "revokes integration access (deletes from db)" do
        expect {
          AdoptAPetJob.new(@shelter.id).perform
        }.to change(Integration, :count).by(-1)
        expect(
          Integration.where(:id => @integration.id)
        ).to be_empty
      end

      it "logs message when failure" do
        expect(AdoptAPetJob.logger).to receive(:error).
          with("#{@shelter.id} :: #{@shelter.name} :: failed :: 530 Login authentication failed\n")
        AdoptAPetJob.new(@shelter.id).perform
      end
    end
  end

  describe ".logger" do
    it "returns a logger" do
      logger = AdoptAPetJob.logger
      expect(logger).to be_instance_of(Logger)
      expect(Logger.respond_to?(:filename)).to be_false
    end
  end
end

