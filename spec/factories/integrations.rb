FactoryGirl.define do

  factory :integration do
    username "username"
    password "password"
    shelter
  end

# TODO: Use as a callback and disable like below or mock ftp requests
# # FactoryGirl.define do
#         to_create { |instance|
#     Integration.skip_callback(:save, :before, :connection_successful?)
#     instance.save!
#   }
  # factory :adopt_a_pet_integration, :parent => :integration, :class => "Integration::AdoptAPet" do
  #   type "Integration::AdoptAPet"
  # end

  # factory :petfinder_integration, :parent => :integration, :class => "Integration::Petfinder" do
  #   type "Integration::Petfinder"
  # end
end

