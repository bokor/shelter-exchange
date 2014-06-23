class Admin::IntegrationsController < Admin::ApplicationController
  respond_to :html, :js

  def index
    @petfinder_count = Integration::Petfinder.count
    @adopt_a_pet_count = Integration::AdoptAPet.count
    @access_token_count = Shelter.where("shelters.access_token IS NOT NULL").count

    @api_access = Hash.new([])
    Shelter.includes(:integrations).find_each do |shelter|
      @api_access[shelter] += [:access_token] unless shelter.access_token.blank?

      shelter.integrations.each do |integration|
        @api_access[shelter] += [integration.to_sym]
      end
    end
  end
end

