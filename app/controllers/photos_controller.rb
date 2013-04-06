class PhotosController < ApplicationController
  respond_to :html, :json, :js

  def create
    @attachable = find_polymorphic_class
    @photo = Photo.new(params[:photo].merge(:attachable => @attachable))
    if @photo.save
      respond_to do |format|
        json = PhotoPresenter.new(@photo).to_uploader
        format.html { render :json => json, :content_type => 'text/html', :layout => false }
        format.json { render :json => json	}
      end
    else
      render :json => [{:error => @photo.errors[:base].to_sentence}]
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    render :json => true
  end

  def refresh_gallery
    @attachable = find_polymorphic_class
    @photos = @attachable.photos
    respond_to do |format|
      format.json { render :json => @gallery_photos = PhotoPresenter.new(@photos).to_gallery }
    end
  end
end

