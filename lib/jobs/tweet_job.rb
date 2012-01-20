class Jobs::TweetJob < Struct.new(:animal, :shelter)   
  
  def perform
    type    = " #{indefinite_articlerize(animal.animal_type.name)}" unless animal.other?
    breed   = indefinite_articlerize(animal.full_breed)
    city    = shelter.city.split.join
    state   = US_STATES[shelter.state.to_sym].split.join
    twitter = shelter.twitter
    url     = Googl.shorten("http://www.shelterexchange.org/save_a_life/#{animal.id}").short_url
    tweet   = "Adopt#{type} - #{animal.name}, #{breed} in ##{city} ##{state} #{twitter} #saveanimals #{url}"
    
    Twitter.update(tweet) if tweet.length <= 140
  end
  
  private
  
    def indefinite_articlerize(params_word)
      %w(a e i o u).include?(params_word[0].downcase) ? "an #{params_word}" : "a #{params_word}"
    end
    
end

