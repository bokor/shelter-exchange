require 'rails_helper'

describe DataExport::StatusHistoryPresenter do

  before do
    @status_history = StatusHistory.gen
  end

  describe "#id" do
    it "returns the status_history id" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.id).to eq(@status_history.id)
    end
  end

  describe "#status" do
    it "returns the status_history status" do
      status = AnimalStatus.gen :name => "Adopted"
      @status_history.update_column(:animal_status_id, status.id)
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.status).to eq("Adopted")
    end
  end

  describe "#status_date" do
    it "returns the status_history status_date" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.status_date).to eq(@status_history.status_date)
    end
  end

  describe "#reason" do
    it "returns the status_history reason" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.reason).to eq(@status_history.reason)
    end
  end

    describe "#animal_id" do
    it "returns the status_history animal_id" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.animal_id).to eq(@status_history.animal_id)
    end
  end

  describe "#contact_id" do
    it "returns the status_history contact_id" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.contact_id).to eq(@status_history.contact_id)
    end
  end

  describe "#create_at" do
    it "returns the status_history created_at timestamp" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.created_at).to eq(@status_history.created_at)
    end
  end

  describe "#updated_at" do
    it "returns the status_history updated_at timestamp" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.updated_at).to eq(@status_history.updated_at)
    end
  end

  describe "#to_csv" do

    it "returns the status_history in a csv row format" do
      presenter = DataExport::StatusHistoryPresenter.new(@status_history)
      expect(presenter.to_csv).to eq([
        presenter.id,
        presenter.status,
        presenter.status_date,
        presenter.reason,
        presenter.animal_id,
        presenter.contact_id,
        presenter.created_at,
        presenter.updated_at
      ])
    end
  end

  describe ".csv_header" do
    it "returns the csv header" do
      expect(
        DataExport::StatusHistoryPresenter.csv_header

      ).to eq(["Id", "Status", "Status Date", "Reason", "Animal Id", "Contact Id", "Created At", "Updated At"])
    end
  end

  describe ".as_csv" do
    it "returns a collection in csv format" do
      status_history1 = StatusHistory.gen
      status_history2 = StatusHistory.gen
      csv = []

      DataExport::StatusHistoryPresenter.as_csv([status_history1,status_history2], csv)

      expect(csv).to match_array([
        DataExport::StatusHistoryPresenter.csv_header,
        DataExport::StatusHistoryPresenter.new(status_history1).to_csv,
        DataExport::StatusHistoryPresenter.new(status_history2).to_csv
      ])
    end
  end
end


