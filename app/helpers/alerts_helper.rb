module AlertsHelper
  # def subject_url
  #       subject = controller.controller_name.singularize
  #       alerts_path(:subject_type => subject, :subject_id => controller.instance_variable_get("@#{subject}").id)
  #     end
  def show_alertable_link(alert)
	  if alert.alertable
	    link = link_to alert.alertable.name, polymorphic_path(alert.alertable)
	    display_string = '<span class="alert_animal_name">(' + link + ')</span>'
	    display_string.html_safe
    end
  end
end
