class Twerker
include Sidekiq::Worker

  def perform(hashtag)
    set_twitter_client
    search_twitter(hashtag)
  end

  def set_twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  def search_twitter(hashtag)
    begin
      twitter_request = @client.search(hashtag, :result_type => "recent").collect do |tweet|
        next unless tweet.geo?
        next if Tweet.find_by_full_text(tweet.full_text)
        create_tweet(tweet)
      end
      return Tweet.all
    rescue
      puts twitter_request
      return Tweet.all
    end
  end

  def create_tweet(tweet)
    tweet = Tweet.create({
      handle: tweet.user.screen_name,
      full_text: tweet.full_text,
      latitude: tweet.geo.coordinates[0],
      longitude: tweet.geo.coordinates[1],
      tweeted_on: tweet.created_at
    })
    p tweet.handle
    tweet
  end

end
