class Activity
  def initialize(shelter)
    @current_shelter ||= shelter
    @total_recent = 20
  end

  # TODO :
  #   1) the limit passed in here doesn't do anything.  Maybe update the recent activity methods to
  #      use the limit.  Also look at the @total_recent (think it is the max on the page and document
  #      remove tap and make the sorting more obvious.
  #   2) Remove it as a class.  It is not needed and can just be a class method.
  #   3) Add self. to the front of recent.
  def self.recent(limit=10)
    [].tap do |collection|
      collection << @current_shelter.alerts.recent_activity(10)
      collection << @current_shelter.tasks.recent_activity(10)
      collection << @current_shelter.animals.recent_activity(10)
    end.flatten.sort_by(&:updated_at).reverse.slice(0, @total_recent)
  end

end
