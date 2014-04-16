require "spec_helper"

describe ApplicationHelper, "#title" do
  it "returns content_for title" do
    helper.title("Sample Title")
    expect(
      helper.content_for(:title)
    ).to eq("Sample Title")
  end
end

describe ApplicationHelper, "#javascripts" do
  it "returns javascripts tags for files" do
    helper.javascripts("js/test1.js", "js/test2.js")
    expect(
      helper.content_for(:javascripts)
    ).to eq("<script src=\"/assets/js/test1.js\" type=\"text/javascript\"></script>\n<script src=\"/assets/js/test2.js\" type=\"text/javascript\"></script>")
  end
end

describe ApplicationHelper, "#stylesheets" do
  it "returns stylesheet tags for files" do
    helper.stylesheets("css/test1.css", "css/test2.css")
    expect(
      helper.content_for(:stylesheets)
    ).to eq("<link href=\"/assets/css/test1.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />\n<link href=\"/assets/css/test2.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />")
  end
end

describe ApplicationHelper, "#body_class" do

  it "returns body class name as an identifier" do
    allow(controller).to receive(:controller_name).and_return("dashboard")
    allow(controller).to receive(:action_name).and_return("action")

    expect(
      helper.body_class
    ).to eq("dashboard action_dashboard")
  end

  context "with application disabled" do
    it "returns body class name as an identifier" do
      allow(ShelterExchange.settings).to receive(:app_disabled?).and_return(true)

      expect(
        helper.body_class
      ).to eq("app_disabled")
    end
  end
end

describe ApplicationHelper, "#selected_navigation" do

  it "returns class name current" do
    allow(controller.request).to receive(:fullpath).and_return("/animals")

    expect(
      helper.selected_navigation(:animals)
    ).to eq("current")
  end

  it "returns no class name" do
    allow(controller.request).to receive(:fullpath).and_return("/tasks")

    expect(
      helper.selected_navigation(:animals)
    ).to eq("")
  end
end

describe ApplicationHelper, "#sub_navigation" do

  it "returns class name current" do
    allow(controller.request).to receive(:fullpath).and_return("/animals/notes")

    expect(
      helper.sub_navigation(:notes)
    ).to eq("current")
  end

  it "returns no class name" do
    allow(controller.request).to receive(:fullpath).and_return("/tasks/notes")

    expect(
      helper.selected_navigation(:comments)
    ).to eq("")
  end
end

describe ApplicationHelper, "#has_error_message?" do

  it "returns nil when field has no errors" do
    animal = Animal.gen

    expect(
      helper.has_error_message?(animal, "name")
    ).to be_nil
  end

  it "returns field error in sentence form" do
    animal = Animal.create :name => nil

    expect(
      helper.has_error_message?(animal, "name")
    ).to eq("<p class='error'>Cannot be blank</p>")
  end
end

describe ApplicationHelper, "#create_error_message" do

  it "returns field error in sentence form" do
    expect(
      helper.create_error_message("cannot be blank")
    ).to eq("<p class='error'>Cannot be blank</p>")
  end
end

