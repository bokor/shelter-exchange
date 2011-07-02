class CommentsController < ApplicationController
  respond_to :js
  
  def create
    @commentable = find_polymorphic_class || params[:comment][:commentable_type].classify.constantize.find(params[:comment][:commentable_id])
    @comment = @current_shelter.comments.new(params[:comment].merge(:commentable => @commentable))
    flash[:notice] = "#{@comment.comment} has been created." if @comment.save
  end
  
  def edit
    @comment = @current_shelter.comments.find(params[:id])
  end
  
  def update
    @comment = @current_shelter.comments.find(params[:id])
    flash[:notice] = "#{@comment.comment} has been updated." if @comment.update_attributes(params[:comment])
  end
  
  def destroy
    @comment = @current_shelter.comments.find(params[:id])
    @comment.destroy
  end

end
