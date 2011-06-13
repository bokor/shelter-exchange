ActiveAdmin.register Account, :as => "Overview" do

  index do
    table_for Account.includes(:shelters) do
      column("Subdomain")   {|account| account.subdomain                               } 
      column("Blocked"){|account| account.blocked } 
      column("Blocked Reason")   {|account| account.reason_blocked                       } 
      column("Name")   {|account| link_to account.shelters.first.name, admin_shelter_path(account.shelters.first)                      } 
      column("Street")   {|account| account.shelters.first.street                  } 
    end
  end
end