class Integration < ActiveRecord::Base
  

  # Associations
  #----------------------------------------------------------------------------
  belongs_to :shelter, :readonly => true
  
  # Class Methods - Single Table Inheritance (STI)
  #----------------------------------------------------------------------------
  def self.factory(params = nil)
    if params.has_key?(:type)
      params.delete(:type).constantize.new(params)
    else
      Integration.new(params)
    end
  end
  
  def self.inherited(child)
    child.instance_eval do
      def model_name
        self.superclass.model_name
      end
    end
    super
  end
  
end

#avoid type field warnings like:
# http://www.tatvartha.com/2009/08/rails-single-table-inheritance-changing-inheritance_column-name/
# warning: Object#type is deprecated; use Object#class
# self.inheritance_column = :task_type


# @integration.becomes(params[:integration][:type].constantize)