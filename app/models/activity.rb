class Activity
  def initialize(shelter)
    @current_shelter ||= shelter
    @total_recent = 20
  end
  
  def recent(limit=10)
    [].tap do |collection|
      collection << Alert.recent_activity(@current_shelter.id,10)
      collection << Task.recent_activity(@current_shelter.id, 10)
      collection << Animal.recent_activity(@current_shelter.id, 10)
    end.flatten.sort_by(&:updated_at).reverse.slice(0, @total_recent)
  end
  
end