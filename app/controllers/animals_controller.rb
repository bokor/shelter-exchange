class AnimalsController < ApplicationController
  respond_to :html, :js

  # cache_sweeper :animal_sweeper, :only => [:create, :update, :destroy]

  def index
    @total_animals = @current_shelter.animals.count
    @animals = @current_shelter.animals.active.includes(:animal_type, :animal_status, :photos).paginate(:page => params[:page]).all
    respond_with(@animals)
  end

  def show
    @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :photos, :accommodation => [:location]).find(params[:id])
    # Photos
    @photos = @animal.photos
    @gallery_photos = PhotoPresenter.new(@photos).to_gallery
    @uploader_photos = PhotoPresenter.new(@photos).to_uploader

    @notes = @animal.notes.includes(:documents).all
    @status_histories = @animal.status_histories.includes(:animal_status).all
    @alerts = @animal.alerts.active.all
    @overdue_tasks = @animal.tasks.overdue.active.all
  	@today_tasks = @animal.tasks.today.active.all
  	@tomorrow_tasks = @animal.tasks.tomorrow.active.all
  	@later_tasks = @animal.tasks.later.active.all
  end

  def edit
    @animal = @current_shelter.animals.find(params[:id])
    respond_with(@animal)
  end

  def new
    @animal = @current_shelter.animals.new
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
     @animal.destroy
     flash[:notice] = "#{@animal.name} has been deleted."
     respond_with(@animal)
  end

  def print
    @animal = @current_shelter.animals.includes(:animal_type, :animal_status, :photos, :accommodation => [:location]).find(params[:id])
    @shelter = @current_shelter
    @note_categories = Note::CATEGORIES.select{|c| params[c].present? }
    @notes = @animal.notes.where(:category => @note_categories).all
    @print_layout = params[:print_layout] || "animal_with_notes"

    respond_to do |format|
      format.html {
        # flash[:notice] = "Print format options have been update.  Please review the new print document." if params[:print_layout].present? # means that it was resubmitted with options
        render :template => "animals/print/#{@print_layout}", :layout => "app/print"
      }
      format.pdf {
        pdf = AnimalPdf.new(@animal, @notes, @shelter, params, view_context)
        send_data pdf.render, filename: "animal_#{@animal.id}.pdf", type: Mime::PDF, disposition: "inline"
      }
    end
  end


  def search
    q = params[:q].strip.split.join("%")
    if q.blank?
      @animals = @current_shelter.animals.active.includes(:animal_type, :animal_status, :photos).paginate(:page => params[:page]).all
    else
      @animals = @current_shelter.animals.search(q).paginate(:page => params[:page]).all
    end
  end

  def filter_notes
    filter_param = params[:filter]
    @animal = @current_shelter.animals.find(params[:id])
    if filter_param.blank?
      @notes = @animal.notes.all
    else
      @notes = @animal.notes.where(:category => filter_param).all
    end
  end

  def filter_by_type_status
    @animals = @current_shelter.animals.filter_by_type_status(params[:animal_type_id], params[:animal_status_id]).paginate(:page => params[:page]).all
  end

  def find_animals_by_name
    q = params[:q].strip
    @from_controller = params[:from_controller]
    @animals = q.blank? ? {} : @current_shelter.animals.search_by_name(q).paginate(:page => params[:page]).all
  end

  def auto_complete
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.auto_complete(q)
    render :json => @animals.collect{ |animal| {:id => animal.id, :name => "#{animal.name}" } }.to_json
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an invalid animal!"
    redirect_to animals_path and return
  end

end
