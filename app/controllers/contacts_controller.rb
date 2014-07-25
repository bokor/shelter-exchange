class ContactsController < ApplicationController
  respond_to :html, :js

  def index
    @total_contacts = @current_shelter.contacts.count
    @contacts = @current_shelter.contacts.paginate(:page => params[:page]).all
    respond_with(@contacts)
  end

  def show
    @contact = @current_shelter.contacts.includes(:notes).find(params[:id])
    @notes = @contact.notes.includes(:documents)
    @animals = Animal.
      includes(:status_histories).
      preload(:photos, :animal_type, :animal_status, :status_histories => :animal_status).
      where("status_histories.contact_id" => @contact.id).
      reorder("status_histories.status_date DESC").
      paginate(:page => params[:page])
    respond_with(@contact)
  end

  def edit
    @contact = @current_shelter.contacts.find(params[:id])
    respond_with(@contact)
  end

  def new
    @contact = @current_shelter.contacts.new
    respond_with(@contact)
  end

  def create
    @contact = @current_shelter.contacts.new(params[:contact])
    flash[:notice] = "#{@contact.name} has been created." if @contact.save
    respond_with(@contact)
  end

  def update
    @contact = @current_shelter.contacts.find(params[:id])
    flash[:notice] = "#{@contact.name} has been updated." if @contact.update_attributes(params[:contact])
    respond_with(@contact)
  end

  def destroy
    @contact = @current_shelter.contacts.find(params[:id])
    flash[:notice] = "#{@contact.name} has been deleted." if @contact.destroy
    respond_with(@contact)
  end

  def search
    q = params[:q].strip.split.join("%")
    @contacts = if q.blank?
      @current_shelter.contacts.paginate(:page => params[:page]).all
    else
      @current_shelter.contacts.search(q).paginate(:page => params[:page]).all
    end
  end

  def filter_by_last_name_role
    @contacts = @current_shelter.contacts.
      filter_by_last_name_role(params[:by_last_name], params[:by_role]).
      paginate(:page => params[:page]).all
  end

  def filter_animals_by_status
    contact = @current_shelter.contacts.find(params[:id])
    @animals = Animal.
      includes(:status_histories).
      preload(:photos, :animal_type, :animal_status, :status_histories => :animal_status).
      where("status_histories.contact_id" => contact.id)
    unless params[:by_status].blank?
      @animals = @animals.where("status_histories.animal_status_id" => params[:by_status])
    end
    @animals = @animals.reorder("status_histories.status_date DESC").paginate(:page => params[:page])
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid contact => #{params[:id]}")
    flash[:error] = "You have requested an invalid contact!"
    redirect_to contacts_path and return
  end
end

