module ContactsHelper

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

