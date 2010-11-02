class NotesController < ApplicationController
  respond_to :js
  
  def edit
    @note = Note.find(params[:id])
  end
  
  def update
    @note = Note.find(params[:id])
    # logger.error(":::form_note_category_id => #{params[:note][:note_category_id]}")
    #     logger.error(":::current_note_category_id => #{@note.note_category_id}")
    #     @changed = true unless @note.note_category_id.to_i == params[:note][:note_category_id].to_i
    flash[:notice] = "#{@note.title} has been updated." if @note.update_attributes(params[:note])
  end
  
  def create
    @note = Note.new(params[:note])
    flash[:notice] = "#{@note.title} has been created." if  @note.save
  end
  
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
  end
    
    
end