require "rails_helper"

describe Integration::AdoptAPet do

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  it "validates presence of username" do
    integration = Integration::AdoptAPet.new :username => nil

    expect(integration.valid?).to be_falsey
    expect(integration.errors[:username].size).to eq(1)
    expect(integration.errors[:username]).to match_array(["cannot be blank"])
  end

  it "validates uniqueness of username" do
    Integration.gen :adopt_a_pet, :username => "test"
    integration = Integration::AdoptAPet.new :username => "test"

    expect(integration.valid?).to be_falsey
    expect(integration.errors[:username].size).to eq(1)
    expect(integration.errors[:username]).to match_array(["Already in use with another shelter's account"])
  end

  it "validates presence of password" do
    integration = Integration::AdoptAPet.new :password => nil

    expect(integration.valid?).to be_falsey
    expect(integration.errors[:password].size).to eq(1)
    expect(integration.errors[:password]).to match_array(["cannot be blank"])
  end

  it "validates the connection is successful" do
    integration = Integration::AdoptAPet.new :password => "test", :username => "test"

    expect(integration.valid?).to be_truthy
    expect(integration.errors[:connection_failed].size).to eq(0)
  end

  it "validates the connection is failed" do
    allow(Net::FTP).to receive(:open).and_raise(Net::FTPPermError)

    integration = Integration::AdoptAPet.new :password => "test", :username => "test"

    expect(integration.valid?).to be_falsey
    expect(integration.errors[:connection_failed].size).to eq(1)
    expect(integration.errors[:connection_failed]).to match_array(["Adopt a Pet FTP Username and/or FTP Password is incorrect.  Please Try again!"])
  end

  context "After Save" do
    it "enqueues a job to update remote animals", :delayed_job => true do
      Timecop.freeze(Time.parse("Fri, 14 Feb 2014"))

      shelter = Shelter.gen
      integration = Integration.gen(
        :adopt_a_pet_with_after_save_callback,
        :username => "test", :password => "test", :shelter => shelter
      )

      job = YAML.load(Delayed::Job.last.handler)
      expect(Delayed::Job.last.name).to eq("AdoptAPetJob")
      expect(job.class).to eq(AdoptAPetJob)
      expect(job.instance_variable_get(:@start_time)).to eq("2014-02-14 00:00:00 -0800")
      expect(job.instance_variable_get(:@shelter)).to eq(shelter)
      expect(job.instance_variable_get(:@integration)).to eq(integration)
    end
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, ".model_name" do

  it "returns the model name" do
    expect(Integration::AdoptAPet.model_name).to eq("Integration")
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Integration::AdoptAPet, "#humanize" do

  it "returns a humanized name for the integration" do
    expect(Integration::AdoptAPet.new.humanize).to eq("Adopt a Pet")
  end
end

describe Integration::AdoptAPet, "#to_s" do

  it "returns a string representation of the integration" do
    expect(Integration::AdoptAPet.new.to_s).to eq("adopt_a_pet")
  end
end

describe Integration::AdoptAPet, "#to_sym" do

  it "returns a symbol representation of the integration" do
    expect(Integration::AdoptAPet.new.to_sym).to eq(:adopt_a_pet)
  end
end

