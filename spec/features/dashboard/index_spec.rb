require "rails_helper"

feature "Activity list" do
  login_user

  context "with animals" do

    scenario "shows animals that were created" do
      animal = Animal.gen :shelter => current_shelter, :name => "Billy"

      visit dashboard_path

      within "##{dom_id(animal)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_animal.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Animal")

        expect(find(".title").text).to   eq("A new animal record for Billy has been created.")
        expect(find(".title a").text).to eq("Billy")
        expect(find(".title a")[:href]).to include(animal_path(animal))

        expect(find(".created_at_date").text).to eq(animal.updated_at.strftime("%b %d, %Y"))
      end
    end

    scenario "shows animals when the status updated" do
      status1 = AnimalStatus.gen :name => "old"
      status2 = AnimalStatus.gen :name => "Adopted"
      animal  = Animal.gen! :shelter => current_shelter, :name => "Billy", :animal_status => status1

      animal.update_attributes!({
        :animal_status => status2,
        :updated_at    => Time.now + 10.minutes
      })

      visit dashboard_path

      within "##{dom_id(animal)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_animal.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Animal")

        expect(find(".title").text).to   eq("Billy's status was changed to 'Adopted'")
        expect(find(".title a").text).to eq("Billy's")
        expect(find(".title a")[:href]).to include(animal_path(animal))

        expect(find(".created_at_date").text).to eq(animal.updated_at.strftime("%b %d, %Y"))
      end
    end

    scenario "shows animals that were updated" do
      animal = Animal.gen :shelter => current_shelter, :name => "Billy"

      # Update any other field but status
      animal.name       = "Abbey"
      animal.updated_at = Date.today + 2.days
      animal.save!

      visit dashboard_path

      within "##{dom_id(animal)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_animal.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Animal")

        expect(find(".title").text).to   eq("Abbey's record has been updated.")
        expect(find(".title a").text).to eq("Abbey's")
        expect(find(".title a")[:href]).to include(animal_path(animal))

        expect(find(".created_at_date").text).to eq(animal.updated_at.strftime("%b %d, %Y"))
      end
    end
  end

  context "with tasks" do

    scenario "shows tasks that were created" do
      animal = Animal.gen :shelter => current_shelter, :name => "Billy"
      task1  = Task.gen :shelter => current_shelter, :details => "a new task"
      task2  = Task.gen :shelter => current_shelter, :details => "a new task", :taskable => animal

      visit dashboard_path

      within "##{dom_id(task1)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_task.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Task")

        expect(find(".title").text).to eq("New - a new task.")

        expect(find(".created_at_date").text).to eq(task2.updated_at.strftime("%b %d, %Y"))
      end

      within "##{dom_id(task2)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_task.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Task")

        expect(find(".title").text).to   eq("New - a new task for Billy.")
        expect(find(".title a").text).to eq("Billy")
        expect(find(".title a")[:href]).to include(animal_path(animal))

        expect(find(".created_at_date").text).to eq(task1.updated_at.strftime("%b %d, %Y"))
      end
    end

    scenario "shows tasks that were completed" do
      animal = Animal.gen :shelter => current_shelter, :name => "Billy", :updated_at => Time.now
      task1  = Task.gen \
        :shelter => current_shelter,
        :details => "example task",
        :completed => true,
        :updated_at => Time.now + 1.hour
      task2  = Task.gen \
        :shelter => current_shelter,
        :details => "example taskable task",
        :category => "email",
        :completed => true,
        :taskable => animal,
        :updated_at => Time.now + 2.hour

      visit dashboard_path

      within "##{dom_id(task1)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_task.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Task")

        expect(find(".title").text).to eq("example task is complete.")

        expect(find(".created_at_date").text).to eq(task1.updated_at.strftime("%b %d, %Y"))
      end

      within "##{dom_id(task2)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_task.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Task")

        expect(find(".title").text).to   eq("Email - example taskable task is complete for Billy.")
        expect(find(".title a").text).to eq("Billy")
        expect(find(".title a")[:href]).to include(animal_path(animal))

        expect(find(".created_at_date").text).to eq(task2.updated_at.strftime("%b %d, %Y"))
      end
    end

    scenario "shows tasks that were updated" do
      animal = Animal.gen :shelter => current_shelter, :name => "Billy", :updated_at => Time.now
      task1  = Task.gen \
        :shelter => current_shelter,
        :details => "example task",
        :updated_at => Time.now + 1.hour
      task2  = Task.gen \
        :shelter => current_shelter,
        :details => "example taskable task",
        :category => "email",
        :taskable => animal,
        :updated_at => Time.now + 2.hour

      visit dashboard_path

      within "##{dom_id(task1)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_task.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Task")

        expect(find(".title").text).to eq("example task was updated.")

        expect(find(".created_at_date").text).to eq(task1.updated_at.strftime("%b %d, %Y"))
      end

      within "##{dom_id(task2)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_task.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Task")

        expect(find(".title").text).to   eq("Email - example taskable task was updated for Billy.")
        expect(find(".title a").text).to eq("Billy")
        expect(find(".title a")[:href]).to include(animal_path(animal))

        expect(find(".created_at_date").text).to eq(task2.updated_at.strftime("%b %d, %Y"))
      end
    end
  end

  context "with contacts" do

    scenario "shows contacts that were created" do
      contact = Contact.gen :shelter => current_shelter, :first_name => "Billy", :last_name => "Bob"

      visit dashboard_path

      within "##{dom_id(contact)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_contact.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Contact")

        expect(find(".title").text).to eq("A new contact record for Billy Bob has been created.")
        expect(find(".title a").text).to eq("Billy Bob")
        expect(find(".title a")[:href]).to include(contact_path(contact))

        expect(find(".created_at_date").text).to eq(contact.updated_at.strftime("%b %d, %Y"))
      end
    end

    scenario "shows contacts that were updated" do
      contact = Contact.gen :shelter => current_shelter, :first_name => "Billy", :last_name => "Bob"

      # Update any other field but status
      contact.last_name = "Joe"
      contact.updated_at = Date.today + 2.days
      contact.save!

      visit dashboard_path

      within "##{dom_id(contact)}" do
        icon = find(".type img")
        expect(icon[:src]).to include("icon_contact.png")
        expect(icon[:class]).to include("tooltip")
        expect(icon[:"data-tip"]).to eq("Contact")

        expect(find(".title").text).to eq("Billy Joe has been updated.")
        expect(find(".title a").text).to eq("Billy Joe")
        expect(find(".title a")[:href]).to include(contact_path(contact))

        expect(find(".created_at_date").text).to eq(contact.updated_at.strftime("%b %d, %Y"))
      end
    end
  end

  context "with sorting" do

    scenario "sorts activities by lasted updated" do
      animal1 = Animal.gen :shelter => current_shelter, :updated_at => Time.now - 3.minutes
      animal2 = Animal.gen :shelter => current_shelter, :updated_at => Time.now - 2.minutes
      task1  = Task.gen :shelter => current_shelter, :updated_at => Time.now - 1.minutes
      task2  = Task.gen :shelter => current_shelter,:updated_at => Time.now + 1.minutes
      contact1 = Contact.gen :shelter => current_shelter, :updated_at => Time.now + 2.minutes
      contact2 = Contact.gen :shelter => current_shelter,:updated_at => Time.now + 3.minutes

      visit dashboard_path

      expect(page.body).to match(/#{dom_id(contact2)}.*?#{dom_id(contact1)}.*?#{dom_id(task2)}.*?#{dom_id(task1)}.*?#{dom_id(animal2)}.*?#{dom_id(animal1)}/m)
    end
  end
end


