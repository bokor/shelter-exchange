class CommentsController < ApplicationController
  # before_filter :authenticate_user!
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
    # @comment = @notable.comments.build(params[:comment])
    @comment = @current_shelter.comments.new(params[:comment].merge(:commentable => @commentable))
    flash[:notice] = "#{@comment.comment} has been created." if  @comment.save
  end
  
  def destroy
    @comment = @current_shelter.comments.find(params[:id])
    @comment.destroy
  end

end
