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

  def export
    @contacts = @current_shelter.contacts
    @contacts = @contacts.where(params[:contact][:by_role].to_sym => true) unless params[:contact][:by_role].blank?

    csvfile = CSV.generate{|csv| Contact::ExportPresenter.as_csv(@contacts, csv) }

    respond_to do |format|
      format.csv{ send_data(csvfile, :filename => "contacts.csv") }
    end
  end

  def import
    file = params[:contact][:file]
    file_reader = open(file.path).read

    # Get the headers for mapping
    @headers = CSV.parse(file_reader).first

    # Create the directory and set up the filepath
    directory = FileUtils::mkdir_p(Rails.root.join("tmp", "contacts", "import"))
    @csv_filepath = File.join(
      directory, "#{current_shelter.id}-#{current_user.id}-#{file.original_filename}"
    )

    # Save the CSV for use in the mapping
    File.open(@csv_filepath, "wb") { |f| f.write(file_reader) }
  end

  def import_mapping
    row_count = 0
    filepath = params[:contact][:csv_filepath]

    # Parse the CSV and create the contacts
    CSV.foreach(filepath, :headers => true) do |row|

      contact = @current_shelter.contacts.new({
        :first_name => row[params[:contact][:first_name_mapping]],
        :last_name => row[params[:contact][:last_name_mapping]],
        :street => row[params[:contact][:street_mapping]],
        :street_2 => row[params[:contact][:street_2_mapping]],
        :city => row[params[:contact][:city_mapping]],
        :state => row[params[:contact][:state_mapping]],
        :zip_code => row[params[:contact][:zip_code_mapping]],
        :email => row[params[:contact][:email_mapping]],
        :phone => row[params[:contact][:phone_mapping]],
        :mobile => row[params[:contact][:mobile_mapping]]
      })

      row_count += 1 if contact.save
    end

    # Delete the Original CSV file from the import action
    File.delete(filepath) rescue nil

    flash[:notice] = "Imported #{row_count} contacts."
    redirect_to contacts_path
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid contact => #{params[:id]}")
    flash[:error] = "You have requested an invalid contact!"
    redirect_to contacts_path and return
  end
end

