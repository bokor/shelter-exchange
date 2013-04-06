class DocumentsController < ApplicationController
  respond_to :html, :json, :js

  def create
    @attachable = find_polymorphic_class
    @document = Document.new(params[:document].merge(:attachable => @attachable))
    if @document.save
      respond_to do |format|
        document = DocumentPresenter.new(@document).to_uploader
        format.html { render :json => document.to_json, :content_type => 'text/html', :layout => false }
        format.json { render :json => document.to_json	}
      end
    else
      render :json => [{:error => @document.errors[:base].to_sentence}]
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    render :json => true
  end
end

