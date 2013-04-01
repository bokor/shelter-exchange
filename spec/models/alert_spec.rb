require "spec_helper"

describe Alert do

  it "should have a default scope" do
    Alert.scoped.to_sql.should == Alert.order('alerts.created_at DESC').to_sql
  end

  it "should require presence of title" do
    alert = Alert.gen
    alert.should have(:no).error_on(:title)

    alert = Alert.gen :title => nil
    alert.should have(1).error_on(:title)
    alert.errors[:title].should == ["cannot be blank"]
  end

  it "should require inclusion of severity" do
    alert = Alert.gen
    alert.should have(:no).error_on(:severity)

    alert = Alert.gen :severity => "#{Alert::SEVERITIES[0]} blah"
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
    shelter = Shelter.gen
    alert = Alert.gen :shelter => shelter

    alert.should respond_to(:shelter)
    alert.shelter.should == shelter
  end

  it "should return a readonly shelter" do
    alert = Alert.gen
    alert.reload.shelter.should be_readonly
  end
end

describe Alert, "#alertable" do

  it "should respond to alertable" do
    Alert.gen.should respond_to(:alertable)
  end

  it "should belong to a alertable object" do
    item   = Item.gen
    animal = Animal.gen
    alert1  = Alert.gen :alertable => item
    alert2  = Alert.gen :alertable => animal

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

    Alert.active.count.should == 1
    Alert.active.all.should include(alert1)
  end
end

describe Alert, ".stopped" do

  it "should return only the stopped non_active alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :stopped => true

    Alert.stopped.count.should == 1
    Alert.stopped.all.should include(alert2)
  end
end

#describe Alert, ".with_alertable" do

  #it "should return only the alerts with alertable objects" do
    #alert1 = Alert.gen
    #alert2 = Alert.gen :alertable => Animal.gen

    #Alert.with_alertable.count.should == 1
    #Alert.with_alertable.all.should include(alert2)
  #end
#end

describe Alert, ".for_shelter" do

  it "should return only the shelter wide alerts" do
    alert1 = Alert.gen
    alert2 = Alert.gen :alertable => Animal.gen

    Alert.for_shelter.count.should == 1
    Alert.for_shelter.all.should include(alert1)
  end
end

describe Alert, ".for_animals" do

  it "should return only the alerts assigned to an animal" do
    alert1 = Alert.gen
    alert2 = Alert.gen :alertable => Animal.gen
    alert3 = Alert.gen :alertable => Item.gen

    Alert.for_animals.count.should == 1
    Alert.for_animals.all.should include(alert2)
  end
end


#describe Alert, ".recent_activity" do
  #def self.recent_activity(limit=10)
    #with_alertable.reorder("alerts.updated_at DESC").limit(limit)
  #end
#end

#describe Alert, "#stopped?" do
  #def stopped?
    #self.stopped
  #end
#end

#describe Alert, "#active?" do
  #def active?
    #!self.stopped
  #end
#end

#describe Alert, "#alertable?" do
  #def alertable?
    #!!self.alertable
  #end
#end

