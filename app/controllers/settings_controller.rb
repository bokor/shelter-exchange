class SettingsController < ApplicationController
  before_filter :authorize_settings!
  respond_to :html, :js

  def index
    @tab = params[:tab]
    send(@tab) unless @tab.blank?
  end

  def create
    @setting = @current_shelter.settings.new(params[:setting])
    if @setting.save
      flash[:notice] = "Settings have been updated."
    else
      error_message = ""
      error_message += "Type is required and can not have multiple contracts" unless @setting.errors[:animal_type_id].blank?
      error_message += " and " if @setting.errors[:animal_type_id].present? && @setting.errors[:adoption_contract].present?
      error_message += "Adoption Contract is required" unless @setting.errors[:adoption_contract].blank?
      flash[:error] = error_message
    end

    redirect_to setting_path(:tab => params[:tab])
  end

  def update
    @setting = @current_shelter.settings.find(params[:id])

    if @setting.update_attributes(params[:setting])
      flash[:notice] = "Settings have been updated."
    else
      flash[:error] = "Adoption Contract is required" unless @setting.errors[:adoption_contract].blank?
    end

    redirect_to setting_path(:tab => params[:tab])
  end

  def destroy
    @setting = @current_shelter.settings.find(params[:id])
    flash[:notice] = "Settings has been deleted." if @setting.destroy
    redirect_to setting_path(:tab => params[:tab])
  end

  #----------------------------------------------------------------------------
  private

  def authorize_settings!
    authorize!(:view_settings, User)
  end

  # Tab Actions
  #----------------------------------------------------------------------------
  def change_owner
    @users = @current_account.users.all
    @owner = @current_account.users.where(:role => :owner).first
  end

  def animal_profile
    @settings = @current_shelter.settings.includes(:animal_type).all
  end

  def web_access
  end

  def auto_upload
    @adopt_a_pet = Integration::AdoptAPet.where(:shelter_id => @current_shelter).first_or_initialize
    @petfinder   = Integration::Petfinder.where(:shelter_id => @current_shelter).first_or_initialize
  end
end

