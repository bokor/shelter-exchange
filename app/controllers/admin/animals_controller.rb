class Admin::AnimalsController < Admin::ApplicationController
  respond_to :html, :js

  def index
    @latest_adopted    = Animal.latest(:adopted, 50).reorder("animals.status_change_date DESC").all
    @latest_euthanized = Animal.latest(:euthanized, 10).reorder("animals.status_change_date DESC").all
  end

  def live_search
    q = params[:q].strip
    animals = Animal.joins(:shelter).search_by_name(q)

    if params[:shelters] && params[:shelters][:state].present?
      animals = animals.where(:shelters => params[:shelters])
    end

    @animals = animals.all
  end
end
