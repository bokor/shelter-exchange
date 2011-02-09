class CommentsController < ApplicationController
  # load_and_authorize_resource
  respond_to :js
  
  def edit
    @comment = @current_shelter.comments.find(params[:id])
  end
  
  def update
    @comment = @current_shelter.comments.find(params[:id])
    flash[:notice] = "#{@comment.comment} has been updated." if @comment.update_attributes(params[:comment])
  end
  
  def create
    @commentable = find_polymorphic_class
    @comment = @current_shelter.comments.new(params[:comment].merge(:commentable => @commentable))
    flash[:notice] = "#{@comment.comment} has been created." if  @comment.save
  end
  
  def destroy
    @comment = @current_shelter.comments.find(params[:id])
    @comment.destroy
  end

end
