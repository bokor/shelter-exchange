class NotesController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :js
  
  def edit
    @note = @current_shelter.notes.find(params[:id])
  end
  
  def update
    @note = @current_shelter.notes.find(params[:id])
    flash[:notice] = "#{@note.title} has been updated." if @note.update_attributes(params[:note])
  end
  
  def create
    @notable = find_polymorphic_class
    # @note = @notable.notes.build(params[:note])
    @note = @current_shelter.notes.new(params[:note].merge(:notable => @notable))
    flash[:notice] = "#{@note.title} has been created." if  @note.save
  end
  
  def destroy
    @note = @current_shelter.notes.find(params[:id])
    @note.destroy
  end
  
end