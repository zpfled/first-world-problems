get '/' do
  load_tweets
  erb :index
end

get '/problems' do
  @tweets = Tweet.all
  content_type "application/json"
  halt 200, jsonify(@tweets).to_json
end

# Helpers

def load_tweets
  $client.search("#firstworldproblems", :result_type => "recent").collect do |tweet|
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
