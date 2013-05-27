require "spec_helper"

describe "Transfers: For Dashboard Index Page", :js => :true do

  before do
    @account, @user, @shelter = login
  end
end
# Dashboard sidebar
  #<% unless @transfers.blank? %>
    #<div class="transfer_requests">
      #<h2>Transfer Requests</h2>
      #<div id="transfers">
        #<%= render "transfers/transfer_list", :transfers => @transfers %>
      #</div>
    #</div>
	#<% end %>
#<% end %>

