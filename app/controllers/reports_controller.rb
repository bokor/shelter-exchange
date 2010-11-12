class ReportsController < ApplicationController
    respond_to :html, :js

    def index
      # @animals = Animal.all(:include => [:animal_type, :animal_status]).paginate :per_page => Animal::PER_PAGE, :page => params[:page]
      # respond_with(@animals)
    end


   


  end
