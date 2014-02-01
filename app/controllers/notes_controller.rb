class NotesController < ApplicationController
  respond_to :js

  def show
    @note = @current_shelter.notes.includes(:documents).find(params[:id])
  end

  def create
    @notable = find_polymorphic_class
    @note = @current_shelter.notes.new(params[:note].merge(:notable => @notable))
    flash[:notice] = "#{@note.title} has been created." if  @note.save
  end

  def edit
    @note = @current_shelter.notes.find(params[:id])
  end

  def update
    @note = @current_shelter.notes.find(params[:id])
    flash[:notice] = "#{@note.title} has been updated." if @note.update_attributes(params[:note])
  end

  def destroy
    @note = @current_shelter.notes.find(params[:id])
    @note.destroy
  end
end

