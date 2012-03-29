class Activity
  def initialize(shelter)
    @current_shelter ||= shelter
    @total_recent = 20
  end
  
  def recent(limit=10)
    [].tap do |collection|
      collection << @current_shelter.alerts.recent_activity(10)
      collection << @current_shelter.tasks.recent_activity(10)
      collection << @current_shelter.animals.recent_activity(10)
    end.flatten.sort_by(&:updated_at).reverse.slice(0, @total_recent)
  end
  
end