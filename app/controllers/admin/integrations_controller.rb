class Admin::IntegrationsController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    integrations       = Integration.includes(:shelter).all
    @petfinder_count   = integrations.select{|i| i.class.to_sym == :petfinder }.count
    @adopt_a_pet_count = integrations.select{|i| i.class.to_sym == :adopt_a_pet }.count
    
    @integrations_hash = Hash.new([])
    integrations.each do |integration|
      @integrations_hash[integration.shelter.name] += [integration.class.to_sym]
    end
  end
end