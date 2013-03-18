module Parent::Searchable
  extend ActiveSupport::Concern

  module ClassMethods

    def search(q, parent_params)
      scope = self.scoped
      phone = q.gsub(/\D/, "").blank? ? q : q.gsub(/\D/, "")

      if phone.is_numeric?
        scope = scope.where("phone = ? OR mobile = ?", phone, phone)
      else
       scope = scope.where("email = ? OR email_2 = ? OR name like ?", q, q, "%#{q}%")
      end
      scope = scope.where(parent_params)
      scope
    end

  end
end

