class ExportsController < ApplicationController
  require 'csv'
  respond_to :csv

  def all_animals
    @animals = @current_shelter.animals.includes(:animal_type, :animal_status).reorder(nil).limit(nil).all
    respond_to do |format|       
      format.csv{ send_data(all_animals_csv(@animals), :filename => "#{@current_shelter.name.parameterize}-animals.csv") }
    end
  end
  
  private
    def all_animals_csv(results)
      CSV.generate{|csv| 
        csv << Animal::ExportPresenter.csv_header
        @animals.each {|animal| csv << Animal::ExportPresenter.new(animal).to_csv}
      }
    end
end

#  ENABLE - if I reinstate comma gem
#   def all_animals
#     @animals = @current_shelter.animals.includes(:animal_type, :animal_status).reorder(nil).limit(nil).all
#     respond_to do |format|       
#       format.csv { 
#         render :csv => @animals, :filename => "#{@current_shelter.name.parameterize}-animals"
#       } 
#     end
#   end


# comma :default do 
#   id
#   name
#   animal_type :name => "Type" 
#   animal_status :name => "Status"
#   is_mix_breed("Mixed breed") {|i| i == true ? "Y" : "N" }
#   primary_breed
#   secondary_breed
#   microchip
#   is_sterilized("Sterilized") {|i| i == true ? "Y" : "N" }
#   sex {|i| i.humanize }
#   size
#   color
#   weight
#   date_of_birth
#   arrival_date
#   photo {|photo| photo.url(:large) unless photo.url(:large).include?("default_large_photo") }
#   video_url
#   has_special_needs("Special needs") {|i| i == true ? "Y" : "N" }
#   special_needs
#   description
# end

# comma :adopt_a_pet do 
#   id
#   name
#   animal_type :name => "Type" 
#   animal_status :name => "Status"
#   is_mix_breed("Mixed breed") {|i| i == true ? "Y" : "N" }
#   primary_breed
#   secondary_breed
#   microchip
#   is_sterilized("Sterilized") {|i| i == true ? "Y" : "N" }
#   sex {|i| i.humanize }
#   size
#   color
#   weight
#   date_of_birth
#   arrival_date
#   photo {|photo| photo.url(:large) unless photo.url(:large).include?("default_large_photo") }
#   video_url
#   has_special_needs("Special needs") {|i| i == true ? "Y" : "N" }
#   special_needs
#   description
# end