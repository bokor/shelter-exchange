class Activity

  LIMIT = 10
  PAGE_TOTAL = 20

  def self.recent(shelter)
    [].tap do |collection|
      collection << shelter.tasks.recent_activity(LIMIT)
      collection << shelter.contacts.recent_activity(LIMIT)
      collection << shelter.animals.recent_activity(LIMIT)
    end.flatten.sort_by(&:updated_at).reverse.slice(0, PAGE_TOTAL)
  end
end

