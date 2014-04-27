class Api::V1::AnimalPresenter < Presenter

  def initialize(animal)
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
        :age_range => @animal.age.humanize,
        :date_of_birth => @animal.date_of_birth,
        :date_of_birth_in_text => help.humanize_dob(@animal.date_of_birth),
        :size => Animal::SIZES[@animal.size.to_sym],
        :color => @animal.color,
        :microchip => @animal.microchip,
        :has_special_needs => @animal.special_needs?,
        :special_needs => help.auto_link(help.simple_format(@animal.special_needs), :all, :target => "_blank"),
        :description => @animal.description.blank? ? "No description provided" : help.auto_link( help.simple_format(@animal.description), :all, :target => "_blank"),
        :weight => @animal.weight,
        :sex => @animal.sex.humanize,
        :euthanasia_info => {
          :arrival_date => help.format_date_for(@animal.arrival_date),
          :hold_time => @animal.hold_time.present? ? "#{@animal.hold_time} days" : "",
          :euthanasia_date => help.format_date_for(@animal.euthanasia_date)
        },
        :photos => photos,
        :video => you_tube_url,
        :url => public_save_a_life_url(@animal)
      }
    }
  end

  private

    def you_tube_url
      unless @animal.video_url.blank?
        you_tube_id = @animal.video_url.match(VIDEO_URL_REGEX)[5]
        "http://www.youtube.com/watch?v=#{you_tube_id}" unless you_tube_id.blank?
      end
    end

    def photos
      unless @animal.photos.blank?
        @animal.photos.collect do |photo|
          {
            :photo => {
              :thumbnail => photo.image.thumb.url,
              :small => photo.image.small.url,
              :large => photo.image.url
            }
          }
        end
      end
    end

end
