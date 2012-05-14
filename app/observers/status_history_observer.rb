class StatusHistoryObserver < ActiveRecord::Observer
  
  def after_save(status_history)
    # Removed because of the massive amounts of tweets
    # send_tweet(status_history.animal, status_history.shelter) if Rails.env.production?
  end
  
  private
  
    def send_tweet(animal, shelter)
      Delayed::Job.enqueue(ShelterExchange::Jobs::TweetJob.new(animal, shelter)) if animal.available_for_adoption?
    end

end