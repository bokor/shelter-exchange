module ApplicationHelper
  
  def title(title)
    content_for(:title) { title }
  end
  
  def javascripts(*files)
    content_for(:javascripts) { javascript_include_tag(*files) }
  end
  
  def stylesheets(*files)
    content_for(:stylesheets) { stylesheet_include_tag(*files) }
  end
  
  def format_date(type, date)
    case type
      when :short_no_year 
        date.strftime("%b %d")
      when :short
        date.strftime("%b %d, %y")
      when :long 
        date.strftime("%B %d, %Y")
      when :long_day_of_week
        date.strftime("%a %B %d, %Y")
      when :default
        date.strftime("%m.%d.%Y")
    end
  end
  
  def current_year
    Time.now.year
  end
  
end