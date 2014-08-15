require "spec_helper"

describe ContactsHelper, "#formatted_name_for" do

  it "returns last_name, first_name string" do
    contact = Contact.gen :first_name => "Joe", :last_name => "Smith"

    expect(
      helper.formatted_name_for(contact)
    ).to eq("Smith, Joe")
  end

  it "returns last_name only string" do
    contact = Contact.gen :first_name => "", :last_name => "Smith"

    expect(
      helper.formatted_name_for(contact)
    ).to eq("Smith")
  end

  it "returns first_name only string" do
    contact = Contact.gen :first_name => "Joe", :last_name => ""

    expect(
      helper.formatted_name_for(contact)
    ).to eq("Joe")
  end
end
