class AnimalsController < ApplicationController
  respond_to :html, :js, :csv

  def index
    @total_animals = @current_shelter.animals.count
    @animals = @current_shelter.animals.active.includes(:animal_type, :animal_status, :photos).paginate(:page => params[:page]).all
    respond_with(@animals)
  end

  def show
    @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :photos, :accommodation => [:location]).find(params[:id])

    # Photos
    @photos          = @animal.photos
    @gallery_photos  = PhotoPresenter.as_gallery_collection(@photos)
    @uploader_photos = PhotoPresenter.as_uploader_collection(@photos)

    @notes            = @animal.notes.includes(:documents).all
    @status_histories = @animal.status_histories.includes(:animal_status, :contact).all
    @overdue_tasks    = @animal.tasks.overdue.active.all
    @today_tasks      = @animal.tasks.today.active.all
    @tomorrow_tasks   = @animal.tasks.tomorrow.active.all
    @later_tasks      = @animal.tasks.later.active.all
  end

  def edit
    @animal = @current_shelter.animals.find(params[:id])
    respond_with(@animal)
  end

  def new
    @animal = @current_shelter.animals.build(params[:animal])
    respond_with(@animal)
  end

  def create
    @animal = @current_shelter.animals.new(params[:animal])
    flash[:notice] = "#{@animal.name} has been created." if @animal.save
    respond_with(@animal)
  end

  def update
    @animal = @current_shelter.animals.find(params[:id])
    flash[:notice] = "#{@animal.name} has been updated." if @animal.update_attributes(params[:animal])
    respond_with(@animal)
  end

  def destroy
    @animal = @current_shelter.animals.find(params[:id])
    flash[:notice] = "#{@animal.name} has been deleted." if @animal.destroy
    respond_with(@animal)
  end

  def print
    @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :shelter, :photos, :accommodation => [:location]).find(params[:id])
    @shelter = @animal.shelter
    @note_categories = Note::CATEGORIES.select{|c| params[c].present? }

    @notes = if params[:hidden]
      @animal.notes.includes(:documents).where(:category => @note_categories).all
    else
      @animal.notes.includes(:documents).without_hidden.where(:category => @note_categories).all
    end

    @print_layout = params[:print_layout] || "kennel_card"

    respond_to do |format|
      format.html {
        render :template => "animals/print/#{@print_layout}", :layout => "app/print"
      }
    end
  end

  def search
    q = params[:q].strip.split.join("%")
    @animals = if q.blank?
      @current_shelter.animals.active.includes(:animal_type, :animal_status, :photos).paginate(:page => params[:page]).all
    else
      @current_shelter.animals.search(q).paginate(:page => params[:page]).all
    end
  end

  def filter_notes
    filter_param = params[:filter]
    @animal = Animal.find(params[:id])

    @notes = if filter_param.blank?
      @animal.notes.includes(:documents).all
    else
      @animal.notes.includes(:documents).where(:category => filter_param).all
    end
  end

  def filter_by_type_status
    @animals = @current_shelter.animals.filter_by_type_status(params[:animal_type_id], params[:animal_status_id]).paginate(:page => params[:page]).all
  end

  def find_animals_by_name
    @animals = {}

    unless params[:q].blank?
      q = params[:q].strip
      @animals = @current_shelter.animals.search_by_name(q).paginate(:page => params[:page]).all
    end
  end

  def auto_complete
    json = []

    unless params[:q].blank?
      q = params[:q].strip
      @animals = @current_shelter.animals.auto_complete(q)
      json = @animals.collect{ |animal| { :id => animal.id, :name => animal.name } }
    end

    render :json => json.to_json
  end

  def export
    type_id = params[:animal][:animal_type_id] rescue nil
    status_id = params[:animal][:animal_status_id] rescue nil
    animals = @current_shelter.animals.includes(:animal_type, :animal_status, :photos, :accommodation).reorder(nil)

    # Adding Type and Status Filtering
    animals = animals.where(:animal_type_id => type_id) unless type_id.blank?
    animals = animals.where(:animal_status_id => status_id) unless status_id.blank?

    respond_to do |format|
      format.csv{
        csvfile = CSV.generate{|csv| Animal::ExportPresenter.as_csv(animals, csv) }
        send_data(csvfile, :filename => "#{@current_shelter.name.parameterize}-animals.csv")
      }
    end
  end

  # goes at the top rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an invalid animal!"
    redirect_to animals_path and return
  end
end

