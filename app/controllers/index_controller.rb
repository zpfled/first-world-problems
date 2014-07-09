require_relative '../models/twerker'

get '/' do
  load_new_tweets('#firstworldproblems')
  erb :index
  # redirect '/problems'
end

get '/problems' do
  redirect '/' unless request.xhr?
  @tweets = Tweet.all
  content_type "application/json"
  halt 200, jsonify_tweets
end

# Helpers

def load_new_tweets(hashtag)
  Twerker.perform_async(hashtag)
end

def jsonify_tweets
  tweets_hash = {}
  @tweets.each do |tweet|
    tweets_hash["#{tweet.id - 1}"] = {
      full_text: tweet.full_text,
      handle: (tweet.handle == "" ? "someone" : tweet.handle),
      latitude: tweet.latitude,
      longitude: tweet.longitude
    }
  end
  tweets_hash["length"] = @tweets.length
  tweets_hash.to_json
end
