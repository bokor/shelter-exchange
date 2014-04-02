class ContactsController < ApplicationController
  respond_to :html, :js

  def index
    @total_contacts = @current_shelter.contacts.count
    @contacts = @current_shelter.contacts.paginate(:page => params[:page]).all
    respond_with(@contacts)
  end

  def show
    @contact = @current_shelter.contacts.includes(:notes).find(params[:id])
    @notes = @contact.notes
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

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid contact => #{params[:id]}")
    flash[:error] = "You have requested an invalid contact!"
    redirect_to contacts_path and return
  end
end

