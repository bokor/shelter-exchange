module DashboardHelper

  def activity_message_for(object)
    send(object.class.name.to_s.downcase + "_message", object)
  end

  def animal_message(animal)
    if animal.updated_at == animal.created_at
      "A new animal record for #{link_to animal.name, animal} has been created."
    elsif animal.status_change_date == animal.updated_at.to_date
      "#{link_to animal.name.possessive, animal} status was changed to <strong>'#{animal.animal_status.name}'</strong>"
    else
      "#{link_to animal.name.possessive, animal} record has been updated."
    end.html_safe
  end

  def alert_message(alert)
    title = alert.title.chomp('.')
    if alert.updated_at == alert.created_at
      "New - #{alert.severity.humanize} - #{title}#{show_polymorphic_link(alert)}."
    elsif alert.stopped
      "<span class='stopped'>#{alert.severity.humanize} - #{title} has been stopped#{show_polymorphic_link(alert)}.</span>"
    else
      "#{alert.severity.humanize} - #{title} was updated#{show_polymorphic_link(alert)}."
    end.html_safe
  end

  def task_message(task)
    details = task.details.chomp('.')
    category =  task.category.humanize + " -" unless task.category.blank?

    if task.updated_at == task.created_at
      "New - #{category} #{details}#{show_polymorphic_link(task)}."
    elsif task.completed
      "<span class='completed'>#{category} #{details} is complete#{show_polymorphic_link(task)}.</span>"
    else
      "#{category} #{details} was updated#{show_polymorphic_link(task)}."
    end.html_safe
  end

  def show_polymorphic_link(object)
    if object.is_a?(Alert) and object.alertable
        link = link_to object.alertable.name, polymorphic_path(object.alertable)
        return (" for <span class='polymorphic_link'>#{link}</span>").html_safe
    elsif object.is_a?(Task) and object.taskable
      link = link_to object.taskable.name, polymorphic_path(object.taskable)
      return (" for <span class='polymorphic_link'>#{link}</span>").html_safe
    end
  end
end

