shared_examples_for Statusable do

  # Class Methods
  #----------------------------------------------------------------------------
  describe described_class, ".active" do
    it "returns all of the active records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.active
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".non_active" do
    it "returns all of the non active records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusables = described_class.non_active
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".available" do
    it "returns all of the available records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.available
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".for_capacity" do
    it "returns all of the for capacity records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.for_capacity
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".available_for_adoption" do
    it "returns all of the available for adoption records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.available_for_adoption
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".adoption_pending" do
    it "returns all of the adoption pending records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusables = described_class.adoption_pending
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".adopted" do
    it "returns all of the adopted records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:new_intake])

      statusables = described_class.adopted
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".foster_care" do
    it "returns all of the foster care records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:new_intake])

      statusables = described_class.foster_care
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".reclaimed" do
    it "returns all of the reclaimed records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])

      statusables = described_class.reclaimed
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".euthanized" do
    it "returns all of the euthanized records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusables = described_class.euthanized
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  describe described_class, ".transferred" do
    it "returns all of the transferred records" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])
      statusable3 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusables = described_class.transferred
      statusables.count.should == 2
      statusables.should =~ [statusable1, statusable2]
    end
  end

  # Instance Methods
  #----------------------------------------------------------------------------
  describe described_class, "#available?" do
    it "validates if the #{described_class} available?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusable1.available?.should be_true
      statusable2.available?.should be_false
    end
  end

  describe described_class, "#available_for_adoption?" do
    it "validates if the #{described_class} available_for_adoption?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])

      statusable1.available_for_adoption?.should be_true
      statusable2.available_for_adoption?.should be_false
    end
  end

  describe described_class, "#adopted?" do
    it "validates if the #{described_class} adopted?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adopted])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:new_intake])

      statusable1.adopted?.should be_true
      statusable2.adopted?.should be_false
    end
  end

  describe described_class, "#adoption_pending?" do
    it "validates if the #{described_class} adoption_pending?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoption_pending])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:adoped])

      statusable1.adoption_pending?.should be_true
      statusable2.adoption_pending?.should be_false
    end
  end

  describe described_class, "#reclaimed?" do
    it "validates if the #{described_class} reclaimed?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:reclaimed])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusable1.reclaimed?.should be_true
      statusable2.reclaimed?.should be_false
    end
  end

  describe described_class, "#foster_care?" do
    it "validates if the #{described_class} foster_care?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:foster_care])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusable1.foster_care?.should be_true
      statusable2.foster_care?.should be_false
    end
  end

  describe described_class, "#deceased?" do
    it "validates if the #{described_class} deceased?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:deceased])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusable1.deceased?.should be_true
      statusable2.deceased?.should be_false
    end
  end

  describe described_class, "#euthanized?" do
    it "validates if the #{described_class} euthanized?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:euthanized])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusable1.euthanized?.should be_true
      statusable2.euthanized?.should be_false
    end
  end

  describe described_class, "#transferred?" do
    it "validates if the #{described_class} transferred?" do
      statusable1 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:transferred])
      statusable2 = described_class.gen(:animal_status_id => AnimalStatus::STATUSES[:available_for_adoption])

      statusable1.transferred?.should be_true
      statusable2.transferred?.should be_false
    end
  end
end

