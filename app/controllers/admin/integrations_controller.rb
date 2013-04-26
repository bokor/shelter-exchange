class Admin::IntegrationsController < Admin::ApplicationController
  respond_to :html, :js

  def index
    integrations       = Integration.joins(:shelter).includes(:shelter).order('shelters.name ASC').all

    @petfinder_count   = integrations.select{|i| i.to_sym == :petfinder }.count
    @adopt_a_pet_count = integrations.select{|i| i.to_sym == :adopt_a_pet }.count

    @integrations_hash = Hash.new([])

    integrations.each do |integration|
      @integrations_hash[integration.shelter] += [integration.to_sym]
    end
  end
end
