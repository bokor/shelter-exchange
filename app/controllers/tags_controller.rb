class TagsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :js, :json
  
  def auto_complete
    q = params[:q].strip
    @tags = @current_shelter.owned_tags.where("tags.name like '%#{q}%'").order("tags.name ASC")
    render :json => @tags.collect{ |tag| {:id => "#{tag.id}", :label => "#{tag.name}", :value => "#{tag.name}", :name => "#{tag.name}" } }
  end
  
  def add_tag
    @location = @current_shelter.locations.find(params[:id]) 
    @current_shelter.tag(@location, :with => @location.tag_list << params[:add_tag], :on => :tags)
    @global_tags = @current_shelter.owned_tags.order("tags.name ASC")
    @location_tags = @location.tags
  end
  
  def remove_tag
    q = params[:q].strip
    @tags = @current_shelter.owned_tags.where("tags.name like '%#{q}%'").order("tags.name ASC")
    render :json => @tags.collect{ |tag| {:id => "#{tag.id}", :label => "#{tag.name}", :value => "#{tag.name}", :name => "#{tag.name}" } }
  end
  
end