class AnimalStatus < ActiveRecord::Base
  
  # Constants
  #----------------------------------------------------------------------------
  STATUSES = {
    :available_for_adoption => 1, :adopted => 2, :foster_care => 3, :new_intake => 4, :in_transit => 5,
    :rescue_candidate => 6, :stray_intake => 7, :on_hold_behavioral => 8, :on_hold_medical => 9, :on_hold_bite => 10,
    :on_hold_custody => 11, :reclaim => 12, :deceased => 13, :euthanized => 14 }.freeze
  ACTIVE = [1,3,4,5,6,7,8,9,10,11].freeze
  NON_ACTIVE = [2,12,13,14].freeze
  
  # Associations
  #----------------------------------------------------------------------------
  has_many :animals, :readonly => true
  has_many :status_histories, :dependent => :destroy
  
  # Scopes
  #----------------------------------------------------------------------------
  scope :active, where(:id => ACTIVE)
  scope :non_active, where(:id => NON_ACTIVE)
  
end

