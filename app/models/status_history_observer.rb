class StatusHistoryObserver < ActiveRecord::Observer
  
  def after_save(status_history)
    send_tweet(status_history.animal, status_history.shelter) if Rails.env.production?
  end
  
  private
  
    def send_tweet(animal, shelter)
      url = Googl.shorten("http://www.shelterexchange.org/save_a_life/#{animal.id}").short_url
      type = " #{indefinite_articlerize(animal.animal_type.name)}" unless animal.other?
      tweet = "Adopt#{type} - #{animal.name}, #{indefinite_articlerize(animal.full_breed)} in ##{shelter.city} ##{shelter.state} #{shelter.twitter} #saveanimals #{url}"
      Delayed::Job.enqueue(TweetJob.new(tweet)) if animal.available_for_adoption? and tweet.length <= 140
    end
    
    def indefinite_articlerize(params_word)
        %w(a e i o u).include?(params_word[0].downcase) ? "an #{params_word}" : "a #{params_word}"
    end

end