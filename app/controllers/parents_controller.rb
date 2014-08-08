class ParentsController < ApplicationController
  respond_to :html, :js, :json

  def index
    @parents = Parent.paginate(:page => params[:page]).all
  end

  def search
    q = params[:q].strip.split.join("%")
    parent_params = params[:parents].delete_if{|k,v| v.blank?} if params[:parents]

    @parents = if q.blank?
      Parent.where(parent_params).paginate(:page => params[:page]).all
    else
      Parent.search(q, parent_params).paginate(:page => params[:page]).all
    end
  end

  def migrate
    parent = Parent.find(params[:id])
    contact = @current_shelter.contacts.new(
     :first_name => parent.name.split(" ")[0] || "",
     :last_name => parent.name.split(" ")[1] || "",
     :street => parent.street,
     :city => parent.city,
     :state => parent.state,
     :zip_code => parent.zip_code,
     :phone => parent.phone,
     :mobile => parent.mobile,
     :email => parent.email
    )

    if contact.save

      parent.notes.each do |note|
        note.notable = contact
        note.shelter = @current_shelter
        note.save!
      end

      parent.reload.destroy
      flash[:notice] = "#{contact.first_name} #{contact.last_name} has been moved to Contacts."
    else
      flash[:error] = "Error with parent moving"
    end

    redirect_to parents_path and return
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid parent => #{params[:id]}")
    flash[:error] = "You have requested an invalid parent!"
    redirect_to parents_path and return
  end
end

