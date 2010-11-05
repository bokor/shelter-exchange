class NotesController < ApplicationController
  respond_to :js
  
  def edit
    @note = Note.find(params[:id])
  end
  
  def update
    @note = Note.find(params[:id])
    flash[:notice] = "#{@note.title} has been updated." if @note.update_attributes(params[:note])
  end
  
  def create
    @notable = find_polymorphic_class
    # @note = @notable.notes.build(params[:note])
    @note = Note.new(params[:note].merge(:notable => @notable))
    flash[:notice] = "#{@note.title} has been created." if  @note.save
  end
  
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
  end
  
end