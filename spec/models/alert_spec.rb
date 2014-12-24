require "rails_helper"

describe Alert do

  it "has a default scope" do
    expect(Alert.scoped.to_sql).to eq(Alert.order('alerts.created_at DESC').to_sql)
  end

  it "validates presence of title" do
    alert = Alert.new :title => nil
    expect(alert.error_on(:title).size).to eq(1)
    expect(alert.errors[:title]).to match_array(["cannot be blank"])
  end

  it "validates inclusion of severity" do
    alert = Alert.new :severity => "#{Alert::SEVERITIES[0]} blah"
    expect(alert.error_on(:severity).size).to eq(1)
    expect(alert.errors[:severity]).to match_array(["needs to be selected"])
  end
end

# Constants
#----------------------------------------------------------------------------
describe Alert, "::SEVERITIES" do
  it "contains a default list of severities" do
    expect(Alert::SEVERITIES).to match_array(["high", "medium", "low"])
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Alert, ".active" do

  it "returns only the active alerts" do
    alert1 = Alert.gen
    Alert.gen :stopped => true

    alerts = Alert.active.all

    expect(alerts.count).to eq(1)
    expect(alerts).to match_array([alert1])
  end
end

describe Alert, ".stopped" do

  it "returns only the stopped non_active alerts" do
    alert1 = Alert.gen :stopped => true
    Alert.gen

    alerts = Alert.stopped.all

    expect(alerts.count).to eq(1)
    expect(alerts).to match_array([alert1])
  end
end

describe Alert, ".for_shelter" do

  it "returns only the shelter wide alerts" do
    alert1 = Alert.gen
    Alert.gen :alertable => Animal.gen

    alerts = Alert.for_shelter.all

    expect(alerts.count).to eq(1)
    expect(alerts).to match_array([alert1])
  end
end

describe Alert, ".for_animals" do

  it "returns only the alerts assigned to an animal" do
    alert1 = Alert.gen :alertable => Animal.gen
    Alert.gen

    alerts = Alert.for_animals.all

    expect(alerts.count).to eq(1)
    expect(alerts).to match_array([alert1])
  end
end

describe Alert, ".recent_activity" do

  it "returns only the most recent activity per limit" do
    alert1 = Alert.gen :updated_at => Time.now - 1.hour
    alert2 = Alert.gen :updated_at => Time.now
    Alert.gen :updated_at => Time.now - 2.hour

    alerts = Alert.recent_activity(2).all

    expect(alerts.count).to eq(2)
    expect(alerts).to match_array([alert1, alert2])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Alert, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    alert = Alert.new :shelter => shelter

    expect(alert.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    alert = Alert.gen
    expect(alert.reload.shelter).to be_readonly
  end
end

describe Alert, "#alertable" do

  it "belongs to a alertable object" do
    item = Item.new
    animal = Animal.new
    alert1 = Alert.new :alertable => item
    alert2 = Alert.new :alertable => animal

    expect(alert1.alertable).to eq(item)
    expect(alert1.alertable).to be_instance_of(Item)

    expect(alert2.alertable).to eq(animal)
    expect(alert2.alertable).to be_instance_of(Animal)
  end
end

describe Alert, "#stopped?" do

  it "returns true if the alert is stopped" do
    alert1 = Alert.new :stopped => true
    alert2 = Alert.new

    expect(alert1.stopped?).to eq(true)
    expect(alert2.stopped?).to eq(false)
  end
end

describe Alert, "#active?" do

  it "returns true if the alert is active" do
    alert1 = Alert.new :stopped => true
    alert2 = Alert.new

    expect(alert1.active?).to eq(false)
    expect(alert2.active?).to eq(true)
  end
end

describe Alert, "#alertable?" do

  it "returns true if the note has an alertable association" do
    animal = Animal.new
    alert1 = Alert.new :alertable => animal
    alert2 = Alert.new

    expect(alert1.alertable?).to eq(true)
    expect(alert2.alertable?).to eq(false)
  end
end

