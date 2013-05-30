require "spec_helper"

describe "Activity List: For Dashboard Index Page", :js => :true do

  before do
    @account, @user, @shelter = login
  end

  context "Animals" do

    it "should list animals that were created" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy"

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_animal.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Animal"

        find(".title").text.should   == "A new animal record for Billy has been created."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == animal.updated_at.strftime("%b %d, %Y")
      end
    end

    it "should list animals when the status updated" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy"

      # Update Status Only
      animal.animal_status = AnimalStatus.gen :name => "Adopted"
      animal.updated_at    = Time.now + 1.hour
      animal.save!

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_animal.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Animal"

        find(".title").text.should   == "Billy's status was changed to 'Adopted'"
        find(".title a").text.should == "Billy's"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == animal.updated_at.strftime("%b %d, %Y")
      end
    end

    it "should list animals that were updated" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy"

      # Update any other field but status
      animal.name       = "Abbey"
      animal.updated_at = Date.today + 1.day
      animal.save!

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_animal.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Animal"

        find(".title").text.should   == "Abbey's record has been updated."
        find(".title a").text.should == "Abbey's"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == animal.updated_at.strftime("%b %d, %Y")
      end
    end
  end

  context "Tasks" do

    it "should list tasks that were created" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy"
      task1  = Task.gen :shelter => @shelter, :details => "a new task"
      task2  = Task.gen :shelter => @shelter, :details => "a new task", :taskable => animal

      visit dashboard_path

      within "#activities #activity_1" do
        icon = find(".type img")
        icon[:src].should include("icon_task.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Task"

        find(".title").text.should   == "New - a new task for Billy."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == task1.updated_at.strftime("%b %d, %Y")
      end

      within "#activities #activity_2" do
        icon = find(".type img")
        icon[:src].should include("icon_task.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Task"

        find(".title").text.should == "New - a new task."

        find(".created_at_date").text.should == task2.updated_at.strftime("%b %d, %Y")
      end
    end

    it "should list tasks that were completed" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy", :updated_at => Time.now
      task1  = Task.gen \
        :shelter => @shelter,
        :details => "example task",
        :completed => true,
        :updated_at => Time.now + 1.hour
      task2  = Task.gen \
        :shelter => @shelter,
        :details => "example taskable task",
        :category => "email",
        :completed => true,
        :taskable => animal,
        :updated_at => Time.now + 2.hour

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_task.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Task"

        find(".title").text.should   == "Email - example taskable task is complete for Billy."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == task2.updated_at.strftime("%b %d, %Y")
      end

      within "#activities #activity_1" do
        icon = find(".type img")
        icon[:src].should include("icon_task.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Task"

        find(".title").text.should == "example task is complete."

        find(".created_at_date").text.should == task1.updated_at.strftime("%b %d, %Y")
      end
    end

    it "should list tasks that were updated" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy", :updated_at => Time.now
      task1  = Task.gen \
        :shelter => @shelter,
        :details => "example task",
        :updated_at => Time.now + 1.hour
      task2  = Task.gen \
        :shelter => @shelter,
        :details => "example taskable task",
        :category => "email",
        :taskable => animal,
        :updated_at => Time.now + 2.hour

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_task.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Task"

        find(".title").text.should   == "Email - example taskable task was updated for Billy."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == task2.updated_at.strftime("%b %d, %Y")
      end

      within "#activities #activity_1" do
        icon = find(".type img")
        icon[:src].should include("icon_task.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Task"

        find(".title").text.should == "example task was updated."

        find(".created_at_date").text.should == task1.updated_at.strftime("%b %d, %Y")
      end
    end
  end

  context "Alerts" do

    it "should list alerts that were created" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy"
      alert1 = Alert.gen :shelter => @shelter, :title => "a new alert", :severity => "low"
      alert2 = Alert.gen :shelter => @shelter, :title => "a new alert", :severity => "medium", :alertable => animal

      visit dashboard_path

      within "#activities #activity_1" do
        icon = find(".type img")
        icon[:src].should include("icon_alert.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Alert"

        find(".title").text.should   == "New - Medium - a new alert for Billy."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == alert1.updated_at.strftime("%b %d, %Y")
      end

      within "#activities #activity_2" do
        icon = find(".type img")
        icon[:src].should include("icon_alert.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Alert"

        find(".title").text.should == "New - Low - a new alert."

        find(".created_at_date").text.should == alert2.updated_at.strftime("%b %d, %Y")
      end
    end

    it "should list alerts that were stopped" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy", :updated_at => Time.now
      alert1  = Alert.gen \
        :shelter => @shelter,
        :title => "example alert",
        :stopped => true,
        :severity => "low",
        :updated_at => Time.now + 1.hour
      alert2  = Alert.gen \
        :shelter => @shelter,
        :title => "example alertable alert",
        :stopped => true,
        :severity => "medium",
        :alertable => animal,
        :updated_at => Time.now + 2.hour

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_alert.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Alert"

        find(".title").text.should   == "Medium - example alertable alert has been stopped for Billy."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == alert2.updated_at.strftime("%b %d, %Y")
      end

      within "#activities #activity_1" do
        icon = find(".type img")
        icon[:src].should include("icon_alert.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Alert"

        find(".title").text.should == "Low - example alert has been stopped."

        find(".created_at_date").text.should == alert1.updated_at.strftime("%b %d, %Y")
      end
    end

    it "should list alerts that were updated" do
      animal = Animal.gen :shelter => @shelter, :name => "Billy", :updated_at => Time.now
      alert1  = Alert.gen \
        :shelter => @shelter,
        :title => "example alert",
        :severity => "high",
        :updated_at => Time.now + 1.hour
      alert2  = Alert.gen \
        :shelter => @shelter,
        :title => "example alertable alert",
        :severity => "low",
        :alertable => animal,
        :updated_at => Time.now + 2.hour

      visit dashboard_path

      within "#activities #activity_0" do
        icon = find(".type img")
        icon[:src].should include("icon_alert.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Alert"

        find(".title").text.should   == "Low - example alertable alert was updated for Billy."
        find(".title a").text.should == "Billy"
        find(".title a")[:href].should include(animal_path(animal))

        find(".created_at_date").text.should == alert2.updated_at.strftime("%b %d, %Y")
      end

      within "#activities #activity_1" do
        icon = find(".type img")
        icon[:src].should include("icon_alert.png")
        icon[:class].should include("tooltip")
        icon[:"data-tip"].should == "Alert"

        find(".title").text.should == "High - example alert was updated."

        find(".created_at_date").text.should == alert1.updated_at.strftime("%b %d, %Y")
      end
    end
  end

  context "Ordering" do

    it "should order by lasted updated" do
      animal1 = Animal.gen :shelter => @shelter, :name => "Animal1", :updated_at => Time.now - 3.minutes
      animal2 = Animal.gen :shelter => @shelter, :name => "Animal2", :updated_at => Time.now - 2.minutes
      task1  = Task.gen :shelter => @shelter, :details => "Task1", :updated_at => Time.now - 1.minutes
      task2  = Task.gen :shelter => @shelter, :details => "Task2", :updated_at => Time.now + 1.minutes
      alert1 = Alert.gen :shelter => @shelter, :title => "Alert1", :updated_at => Time.now + 2.minutes
      alert2 = Alert.gen :shelter => @shelter, :title => "Alert2", :updated_at => Time.now + 3.minutes

      visit dashboard_path

      page.body.should =~ /Alert2.*?Alert1.*?Task2.*?Task1.*?Animal2.*?Animal1/m
    end
  end
end

