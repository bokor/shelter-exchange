require "spec_helper"

describe Alert do

  it "has a default scope" do
    Alert.scoped.to_sql.should == Alert.order('alerts.created_at DESC').to_sql
  end

  it "validates presence of title" do
    alert = Alert.new :title => nil
    alert.should have(1).error_on(:title)
    alert.errors[:title].should == ["cannot be blank"]
  end

  it "validates inclusion of severity" do
    alert = Alert.new :severity => "#{Alert::SEVERITIES[0]} blah"
    alert.should have(1).error_on(:severity)
    alert.errors[:severity].should == ["needs to be selected"]
  end
end

# Constants
#----------------------------------------------------------------------------
describe Alert, "::SEVERITIES" do
  it "contains a default list of severities" do
    Alert::SEVERITIES.should == ["high", "medium", "low"]
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Alert, ".active" do

  it "returns only the active alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :stopped => true

    alerts = Alert.active.all

    alerts.count.should == 1
    alerts.should       == [alert1]
  end
end

describe Alert, ".stopped" do

  it "returns only the stopped non_active alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :stopped => true

    alerts = Alert.stopped.all

    alerts.count.should == 1
    alerts.should       == [alert2]
  end
end

describe Alert, ".for_shelter" do

  it "returns only the shelter wide alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :alertable => Animal.gen

    alerts = Alert.for_shelter.all

    alerts.count.should == 1
    alerts.should == [alert1]
  end
end

describe Alert, ".for_animals" do

  it "returns only the alerts assigned to an animal" do
    alert1 = Alert.gen
    alert2 = Alert.gen :alertable => Animal.gen

    alerts = Alert.for_animals.all

    alerts.count.should == 1
    alerts.should       == [alert2]
  end
end

describe Alert, ".recent_activity" do

  it "returns only the most recent activity per limit" do
    alert1 = Alert.gen :updated_at => Time.now - 2.hour
    alert2 = Alert.gen :updated_at => Time.now - 1.hour
    alert3 = Alert.gen :updated_at => Time.now

    alerts = Alert.recent_activity(2).all

    alerts.count.should == 2
    alerts.should       == [alert3, alert2]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Alert, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    alert   = Alert.new :shelter => shelter

    alert.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    alert = Alert.gen
    alert.reload.shelter.should be_readonly
  end
end

describe Alert, "#alertable" do

  it "belongs to a alertable object" do
    item   = Item.new
    animal = Animal.new
    alert1 = Alert.new :alertable => item
    alert2 = Alert.new :alertable => animal

    alert1.alertable.should == item
    alert1.alertable.should be_instance_of(Item)

    alert2.alertable.should == animal
    alert2.alertable.should be_instance_of(Animal)
  end
end

describe Alert, "#stopped?" do

  it "validates if the alert is stopped" do
    alert1 = Alert.new :stopped => true
    alert2 = Alert.new

    alert1.stopped?.should == true
    alert2.stopped?.should == false
  end
end

describe Alert, "#active?" do

  it "validates if the alert is active" do
    alert1 = Alert.new :stopped => true
    alert2 = Alert.new

    alert1.active?.should == false
    alert2.active?.should == true
  end
end

describe Alert, "#alertable?" do

  it "validates if the note has an alertable association" do
    animal = Animal.new
    alert1 = Alert.new :alertable => animal
    alert2 = Alert.new

    alert1.alertable?.should == true
    alert2.alertable?.should == false
  end
end

