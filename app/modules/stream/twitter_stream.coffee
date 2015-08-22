api_keys =
  consumer_key: process.env.CONSUMER_KEY
  consumer_secret: process.env.CONSUMER_SECRET
  access_token: process.env.ACCESS_TOKEN
  access_token_secret: process.env.ACCESS_TOKEN_SECRET

# Dependencies
TwitterApiConnection = require('twit')
ApiClient = new TwitterApiConnection(api_keys)

filter_params =
  # Hashtags/Words to track
  track: '#firstWorldProblems'
  # Locations to track
  locations: [-180, -90, 180, 90]

# Stream Object
module.exports = ApiClient.stream('statuses/filter', filter_params)