class Admin::AnimalsController < Admin::ApplicationController
  respond_to :html, :js

  def index
    @latest_adopted    = Animal.latest(:adopted, 50).all
    @latest_euthanized = Animal.latest(:euthanized, 10).all
  end

  def live_search
    q = params[:q].strip
    animals = Animal.joins(:shelter).search_by_name(q)

    if params[:shelters] && params[:shelters][:state]
      animals = animals.where(:shelters => params[:shelters])
    end

    @animals = animals.all
  end
end
