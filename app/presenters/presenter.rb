class Presenter
  include Rails.application.routes.url_helpers

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

