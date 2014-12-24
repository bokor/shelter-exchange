require "rails_helper"

describe ContactsHelper, "#company_details_for" do

  it "returns title, company_name string" do
    contact = Contact.gen :job_title => "Poo Picker", :company_name => "Shelter Exchange, Inc"

    expect(
      helper.company_details_for(contact)
    ).to eq("<span class='company_details'>Poo Picker - Shelter Exchange, Inc</span>")
  end

  it "returns title only string" do
    contact = Contact.gen :job_title => "Poo Picker", :company_name => ""

    expect(
      helper.company_details_for(contact)
    ).to eq("<span class='company_details'>Poo Picker</span>")
  end

  it "returns company only string" do
    contact = Contact.gen :job_title => "", :company_name => "Shelter Exchange, Inc"

    expect(
      helper.company_details_for(contact)
    ).to eq("<span class='company_details'>Shelter Exchange, Inc</span>")
  end
end

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
