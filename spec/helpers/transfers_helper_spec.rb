require "spec_helper"

describe TransfersHelper, "#status_action_name" do

  it "returns text when approved" do
    transfer = Transfer.gen :status => "approved"

    expect(
      helper.status_action_name(transfer)
    ).to eq("Approve")
  end

  it "returns text when completed" do
    transfer = Transfer.gen :status => "completed"

    expect(
      helper.status_action_name(transfer)
    ).to eq("Complete")
  end

  it "returns text when rejected" do
    transfer = Transfer.gen :status => "rejected"

    expect(
      helper.status_action_name(transfer)
    ).to eq("Reject")
  end
end


