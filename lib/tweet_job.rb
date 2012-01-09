class TweetJob < Struct.new(:tweet)
  
  def perform
    Twitter.update(tweet)
  end    
  
end