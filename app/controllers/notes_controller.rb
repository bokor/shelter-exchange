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
    @subject = find_subject
    @note = @subject.notes.build(params[:note])
    # @note = Note.new(params[:note])
    flash[:notice] = "#{@note.title} has been created." if  @note.save
  end
  
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
  end
  
  private

    def find_subject
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
    
    
end