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

# @integration.becomes(params[:integration][:type].constantize)

  # def self.factory(type, params = nil)
  

# def self.select_options
#   descendants.map{ |c| c.to_s }.sort
# end

# Object.const_get(type).new(params) 

#http://code.alexreisner.com/articles/single-table-inheritance-in-rails.html
# avoid errors like:
# NoMethodError (undefined method `ftp_task_url' for #<TasksController:0x1035e4760>):
# def self.inherited(child)
#   child.instance_eval do
#     def model_name
#       Task.model_name
#     end
#   end
#   super
# end