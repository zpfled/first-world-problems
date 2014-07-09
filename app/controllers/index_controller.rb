require_relative '../models/twerker'

get '/' do
  p $client
  load_new_tweets
  erb :index
end

get '/problems' do
  @tweets = Tweet.all
  content_type "application/json"
  halt 200, jsonify_tweets
end

get '/status/:job_id' do
  # return the status of a job to an AJAX call
end

# Helpers

def load_new_tweets
  Twerker.perform_async
end

def jsonify_tweets
  tweets_hash = {}
  @tweets.each do |tweet|
    tweets_hash["#{tweet.id}"] = {
      latitude: tweet.latitude,
      longitude: tweet.longitude,
      full_text: tweet.full_text
    }
  end
  tweets_hash["count"] = @tweets.length
  tweets_hash.to_json
end

# def job_is_complete(jid)
#   waiting = Sidekiq::Queue.new
#   working = Sidekiq::Workers.new
#   pending = Sidekiq::ScheduledSet.new
#   return false if pending.find { |job| job.jid == jid }
#   return false if waiting.find { |job| job.jid == jid }
#   return false if working.find { |worker, info| info["payload"]["jid"] == jid }
#   true
# end
