class TweetJob < Struct.new(:animal, :shelter)
  
  def perform
    url = "http://www.shelterexchange.org/save_a_life/#{animal.id}"
    type = " #{indefinite_articlerize(animal.full_breed)}" unless animal.other?
    Twitter.update("Adopt#{type} - #{animal.name}, #{indefinite_articlerize(animal.full_breed)} in ##{shelter.city} ##{shelter.state} #{shelter.twitter} #saveanimals #{url}")
  end    
  
  private
    
    def indefinite_articlerize(params_word)
        %w(a e i o u).include?(params_word[0].downcase) ? "an #{params_word}" : "a #{params_word}"
    end
  
end