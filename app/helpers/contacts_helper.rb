module ContactsHelper
  def company_details_for(contact)
    company_details = if contact.job_title.present? && contact.company_name.present?
      "#{contact.job_title} - #{contact.company_name}"
    elsif contact.job_title.present?
      contact.job_title
    elsif contact.company_name.present?
      contact.company_name
    else
      nil
    end

    "<span class='company_details'>#{company_details}</span>".html_safe unless company_details.blank?
  end

  def formatted_name_for(contact)
    if contact.last_name.present? && contact.first_name.present?
      "#{contact.last_name}, #{contact.first_name}"
    elsif contact.last_name.present?
      contact.last_name
    elsif contact.first_name.present?
      contact.first_name
    end
  end
end

