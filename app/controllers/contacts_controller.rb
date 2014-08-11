class ContactsController < ApplicationController
  respond_to :html, :js, :csv

  def index
    @total_contacts = @current_shelter.contacts.count
    @contacts = @current_shelter.contacts.paginate(:page => params[:page]).all
    respond_with(@contacts)
  end

  def show
    @contact = @current_shelter.contacts.includes(:notes => :documents).find(params[:id])
    @notes = @contact.notes
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

  def find_by_full_name
    @contacts = {}

    unless params[:q].blank?
      q = params[:q].strip
      @contacts = @current_shelter.contacts.search_by_name(q).paginate(:page => params[:page]).all
    end
  end

  def import
    # Only handles Outlook format for now
    row_count = 0

    CSV.foreach(params[:contacts][:import_file].path, :headers => true) do |row|
      contact = @current_shelter.contacts.new({
        :first_name => row["First Name"],
        :last_name => row["Last Name"],
        :email => row["E-mail Address"],
        :phone => row["Home Phone"],
        :mobile => row["Mobile Phone"],
        :street => row["Home Street"],
        :street_2 => row["Home Street 2"],
        :city => row["Home City"],
        :state => row["Home State"],
        :zip_code => row["Home Postal Code"]
      })
      row_count += 1 if contact.save(:validate => false)
    end

    flash[:notice] = "Imported #{row_count} contacts"
    redirect_to contacts_path
  end

  def export
    csvfile = CSV.generate do |csv|
      csv << ["First Name", "Last Name", "E-mail Address", "Home Phone", "Mobile Phone", "Home Street", "Home Street 2", "Home City", "Home State", "Home Postal Code", "Categories"]

      @current_shelter.contacts.each do |contact|
        categories = Contact::ROLES.map{ |role| "#{role.humanize}" if contact.send(role) }.compact.join(";")
        csv << [contact.first_name, contact.last_name, contact.email, contact.phone, contact.mobile, contact.street, contact.street_2, contact.city, contact.state, contact.zip_code, categories]
      end
    end

    respond_to do |format|
      format.csv{ send_data(csvfile, :filename => "contacts.csv") }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid contact => #{params[:id]}")
    flash[:error] = "You have requested an invalid contact!"
    redirect_to contacts_path and return
  end
end

