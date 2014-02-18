module ApplicationHelper

  def title(title)
    content_for(:title) { title.to_s }
  end

  def javascripts(*files)
    content_for(:javascripts) { javascript_include_tag(*files) }
  end

  def stylesheets(*files)
    content_for(:stylesheets) { stylesheet_link_tag(*files) }
  end

  def body_class
    body_class = if ShelterExchange.settings.app_disabled?
      "app_disabled"
    else
      "#{controller_name} #{action_name}_#{controller_name}"
    end

    body_class
  end

  def selected_navigation(element)
    request.fullpath =~ /\/#{element.to_s}/ ? "current" : ""
  end

  def sub_navigation(element)
    (element.to_s == request.fullpath[1..-1].split('/').collect!{|p| p.to_s}.last) ? "current" : ""
  end

  def has_error_message?(object, field)
    create_error_message(object.errors[field].to_sentence) unless object.errors[field].blank?
  end

  def create_error_message(msg)
    ['<p class="error">', msg.capitalize, '</p>'].join.html_safe
  end
end

