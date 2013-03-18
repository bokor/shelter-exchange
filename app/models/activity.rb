class Activity

  def self.recent(shelter)
    limit      = 10
    page_total = 20

    [].tap do |collection|
      collection << shelter.alerts.recent_activity(limit)
      collection << shelter.tasks.recent_activity(limit)
      collection << shelter.animals.recent_activity(limit)
    end.flatten.sort_by(&:updated_at).reverse.slice(0, page_total)
  end
end

