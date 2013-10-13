class Integration < ActiveRecord::Base

  # Callbacks
  #----------------------------------------------------------------------------
  before_validation :clean_data!

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


  #----------------------------------------------------------------------------
  private

  def clean_data!
    attributes.each_value { |v| v.strip! if v.respond_to?(:strip!) }
  end
end

