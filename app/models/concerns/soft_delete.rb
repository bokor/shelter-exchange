module SoftDelete
  extend ActiveSupport::Concern
  
  included do
    define_model_callbacks :soft_delete
    define_model_callbacks :undelete
    default_scope where(:deleted_at => nil)
    class_eval do
      class << self
        alias_method :with_deleted, :unscoped
      end
    end
  end
  
  module ClassMethods
    # Maybe??
    # alias_method :with_deleted, :unscoped
    
    def only_deleted
      unscoped.where('deleted_at IS NOT NULL')
    end
  end
  
  def soft_delete
    run_callbacks :soft_delete do
      update_attribute(:deleted_at, Time.now)
    end
  end
    
  def undelete
    run_callbacks :undelete do
      update_attribute(:deleted_at, nil)
    end
  end
  
end