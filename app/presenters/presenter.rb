class Presenter
  include Rails.application.routes.url_helpers

  def self.as_collection(collection)
    collection.collect{|object| self.new(object)}
  end

  def self.as_csv(collection, csv)
    csv << self.csv_header
    collection.each { |object| csv << self.new(object).to_csv }
  end

  def help
    self.class.help
  end

  def self.help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include DateHelper
    include AnimalsHelper
    include PhotosHelper
    include UrlHelper
  end

end



