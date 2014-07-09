class Twerker
include Sidekiq::Worker

  def perform#(tweet_id)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    client.search("#firstworldproblems", :result_type => "recent").collect do |tweet|
      p "connected!"
      next unless tweet.geo?
      next if Tweet.find_by_full_text(tweet.full_text)
      Tweet.create({
        full_text: tweet.full_text,
        latitude: tweet.geo.coordinates[0],
        longitude: tweet.geo.coordinates[1],
        tweeted_on: tweet.created_at
      })
    end
  end


end
