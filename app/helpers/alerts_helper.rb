module AlertsHelper

  def show_alertable_link(alert)
    if controller_name == "alerts" && alert.alertable
      link = link_to alert.alertable.name, polymorphic_path(alert.alertable)
      "<span class='alertable_link'>(#{link})</span>".html_safe
    end
  end
end

