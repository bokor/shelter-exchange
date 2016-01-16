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

  def contact_message(contact)
    if contact.updated_at == contact.created_at
      full_name = "#{contact.first_name} #{contact.last_name}"
      "A new contact record for #{link_to full_name, contact} has been created."
    else
      "<a href=\"#{contact_path(contact)}\">#{contact.first_name} #{contact.last_name}</a> has been updated."
    end.html_safe
  end

  def show_polymorphic_link(object)
    if object.is_a?(Task) and object.taskable
      link = link_to object.taskable.name, polymorphic_path(object.taskable)
      " for <span class='polymorphic_link'>#{link}</span>".html_safe
    end
  end
end

