class Api::V1::AnimalPresenter < BasePresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ApplicationHelper
  include AnimalsHelper
  include UrlHelper
  
  def initialize( animal )
    @animal = animal
  end

  def as_json(*args)
    { 
      :animal => { 
    	  :id => @animal.id,
        :name => @animal.name,
        :type => @animal.animal_type.name,
        :status => @animal.animal_status.name,
        :mixed_breed => @animal.mix_breed?,
        :primary_breed => @animal.primary_breed,
        :secondary_breed => @animal.secondary_breed,
        :full_breed_in_text => @animal.full_breed,
        :sterilized => @animal.sterilized? ? true : false,
        :date_of_birth => @animal.date_of_birth,
        :date_of_birth_in_text => humanize_dob(@animal.date_of_birth),
        :size => @animal.size,
        :color => @animal.color,
        :microchip => @animal.microchip,
        :has_special_needs => @animal.special_needs?,
        :special_needs => auto_link(simple_format(@animal.special_needs), :all, :target => "_blank"),
        :description => @animal.description.blank? ? "No description provided" : auto_link( simple_format(@animal.description), :all, :target => "_blank"),
        :weight => @animal.weight,
        :sex => @animal.sex.to_s.humanize,
        :euthanasia_info => {
          :arrival_date => format_date(:default, @animal.arrival_date),
          :hold_time => @animal.hold_time.present? ? "#{@animal.hold_time} days" : "",
          :euthanasia_date => format_date(:default, @animal.euthanasia_date)
        },
        :photo => {
          :thumbnail => photo(:thumbnail),
          :small => photo(:small),
          :large => photo(:large)
        },
        :video => @animal.video_url,
        :url => public_save_a_life_url(@animal, :subdomain => "www")
  	  }
    }
  end
  
  private
  
    def photo(size)
      @animal.photo.url(size).include?("default_#{size.to_s}_photo") ? "" : @animal.photo.url(size)
    end

end