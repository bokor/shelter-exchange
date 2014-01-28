shared_examples_for Statusable do

  # Class Methods
  #----------------------------------------------------------------------------
  describe described_class, ".active" do
    it "returns all of the active records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.active
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".non_active" do
    it "returns all of the non active records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusables = described_class.non_active
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".available" do
    it "returns all of the available records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.available
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".for_capacity" do
    it "returns all of the for capacity records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.for_capacity
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".available_for_adoption" do
    it "returns all of the available for adoption records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.available_for_adoption
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".adoption_pending" do
    it "returns all of the adoption pending records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.adoption_pending
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".adopted" do
    it "returns all of the adopted records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:new_intake])

      statusables = described_class.adopted
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".foster_care" do
    it "returns all of the foster care records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:new_intake])

      statusables = described_class.foster_care
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".reclaimed" do
    it "returns all of the reclaimed records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])

      statusables = described_class.reclaimed
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".euthanized" do
    it "returns all of the euthanized records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusables = described_class.euthanized
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  describe described_class, ".transferred" do
    it "returns all of the transferred records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])
      described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusables = described_class.transferred
      expect(statusables.count).to eq(2)
      expect(statusables).to match_array([statusable1, statusable2])
    end
  end

  # Instance Methods
  #----------------------------------------------------------------------------
  describe described_class, "#available?" do
    it "returns true if the #{described_class} available?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      expect(statusable1.available?).to be_true
      expect(statusable2.available?).to be_false
    end
  end

  describe described_class, "#available_for_adoption?" do
    it "returns true if the #{described_class} available_for_adoption?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      expect(statusable1.available_for_adoption?).to be_true
      expect(statusable2.available_for_adoption?).to be_false
    end
  end

  describe described_class, "#adopted?" do
    it "returns true if the #{described_class} adopted?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:new_intake])

      expect(statusable1.adopted?).to be_true
      expect(statusable2.adopted?).to be_false
    end
  end

  describe described_class, "#adoption_pending?" do
    it "returns true if the #{described_class} adoption_pending?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoped])

      expect(statusable1.adoption_pending?).to be_true
      expect(statusable2.adoption_pending?).to be_false
    end
  end

  describe described_class, "#reclaimed?" do
    it "returns true if the #{described_class} reclaimed?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      expect(statusable1.reclaimed?).to be_true
      expect(statusable2.reclaimed?).to be_false
    end
  end

  describe described_class, "#foster_care?" do
    it "returns true if the #{described_class} foster_care?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      expect(statusable1.foster_care?).to be_true
      expect(statusable2.foster_care?).to be_false
    end
  end

  describe described_class, "#deceased?" do
    it "returns true if the #{described_class} deceased?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:deceased])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      expect(statusable1.deceased?).to be_true
      expect(statusable2.deceased?).to be_false
    end
  end

  describe described_class, "#euthanized?" do
    it "returns true if the #{described_class} euthanized?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      expect(statusable1.euthanized?).to be_true
      expect(statusable2.euthanized?).to be_false
    end
  end

  describe described_class, "#transferred?" do
    it "returns true if the #{described_class} transferred?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      expect(statusable1.transferred?).to be_true
      expect(statusable2.transferred?).to be_false
    end
  end
end

