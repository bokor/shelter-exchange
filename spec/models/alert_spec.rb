require "spec_helper"

describe Alert do

  it "should have a default scope" do
    Alert.scoped.to_sql.should == Alert.order('alerts.created_at DESC').to_sql
  end

  it "should require presence of title" do
    alert = Alert.new :title => nil
    alert.should have(1).error_on(:title)
    alert.errors[:title].should == ["cannot be blank"]
  end

  it "should require inclusion of severity" do
    alert = Alert.new :severity => "#{Alert::SEVERITIES[0]} blah"
    alert.should have(1).error_on(:severity)
    alert.errors[:severity].should == ["needs to be selected"]
  end
end

describe Alert, "::SEVERITIES" do
  it "should contain a default list of severities" do
    Alert::SEVERITIES.should == ["high", "medium", "low"]
  end
end

describe Alert, "#shelter" do

  it "should belong to a shelter" do
    shelter = Shelter.new
    alert   = Alert.new :shelter => shelter

    alert.shelter.should == shelter
  end

  it "should return a readonly shelter" do
    alert = Alert.gen
    alert.reload.shelter.should be_readonly
  end
end

describe Alert, "#alertable" do

  it "should belong to a alertable object" do
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

# Class Methods
#----------------------------------------------------------------------------
describe Alert, ".active" do

  it "should return only the active alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :stopped => true

    results = Alert.active.all

    results.count.should == 1
    results.should       == [alert1]
  end
end

describe Alert, ".stopped" do

  it "should return only the stopped non_active alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :stopped => true

    results = Alert.stopped.all

    results.count.should == 1
    results.should       == [alert2]
  end
end

describe Alert, ".with_alertable" do
pending "Need to implement"

  #it "should include alertable objects" do
    #Alert.gen :alertable => Animal.gen

    #Alert.with_alertable.count.should == 1
    #Alert.with_alertable.all.should include(alert2)
    #Alert.should_receive(:with_alertable).with(:include => :alertable)
    #alert.animal.should be_loaded
    #alert.instance_variables[:@relation].should be_a_kind_of(Animal)
  #end
end

describe Alert, ".for_shelter" do

  it "should return only the shelter wide alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :alertable => Animal.gen

    results = Alert.for_shelter.all

    results.count.should == 1
    results.should == [alert1]
  end
end

describe Alert, ".for_animals" do

  it "should return only the alerts assigned to an animal" do
    alert1 = Alert.gen
    alert2 = Alert.gen :alertable => Animal.gen

    results = Alert.for_animals.all

    results.count.should == 1
    results.should       == [alert2]
  end
end


describe Alert, ".recent_activity" do

  it "should return only the most recent activity per limit" do
    alert1 = Alert.gen
    alert2 = Alert.gen
    alert3 = Alert.gen

    results = Alert.recent_activity(2).all

    results.count.should == 2
    results.should       == [alert3, alert2]
  end
end

describe Alert, "#stopped?" do

  it "should validate if the alert is stopped" do
    alert1 = Alert.new :stopped => true
    alert2 = Alert.new

    alert1.stopped?.should == true
    alert2.stopped?.should == false
  end
end

describe Alert, "#active?" do

  it "should validate if the alert is active" do
    alert1 = Alert.new :stopped => true
    alert2 = Alert.new

    alert1.active?.should == false
    alert2.active?.should == true
  end
end

describe Alert, "#alertable?" do

  it "should validate if the note has an alertable association" do
    animal = Animal.new
    alert1 = Alert.new :alertable => animal
    alert2 = Alert.new

    alert1.alertable?.should == true
    alert2.alertable?.should == false
  end
end

