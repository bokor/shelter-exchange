class IntegrationsController < ApplicationController
  respond_to :js

  def create
    @integration = Integration.factory(params[:integration].merge(:shelter => @current_shelter))
    flash[:notice] = "#{@integration.type.demodulize.underscore.humanize} has been connected." if @integration.save
  end

  def destroy
    @old_integration = @current_shelter.integrations.find(params[:id])
    # Create a new Integration for the type of the old one
    @integration = Integration.factory(:shelter => @current_shelter, :type => @old_integration.type)
    # Destroy the old one
    flash[:notice] = "#{@old_integration.type.demodulize.underscore.humanize} has been revoked." if @old_integration.destroy
  end
end

