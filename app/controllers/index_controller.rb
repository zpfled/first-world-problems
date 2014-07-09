require_relative '../models/twerker'

get '/' do
  p $client
  # load_tweets
  Twerker.perform_async
  erb :index
end

get '/problems' do
  @tweets = Tweet.all
  content_type "application/json"
  halt 200, jsonify(@tweets).to_json
end

# Helpers

def jsonify(tweets)
  tweets_hash = {}
  json_tweets = "{ count: #{tweets.length},"
  tweets.each do |tweet|
    tweets_hash["#{tweet.id}"] = {
      latitude: tweet.latitude,
      longitude: tweet.longitude,
      full_text: tweet.full_text
    }
  end
  tweets_hash["count"] = tweets.length
  tweets_hash
end
