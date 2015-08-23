# Set variables
objectifyTweet = require('../modules/stream/objectifyTweet')
twitter_stream = require('../modules/stream/twitter_stream')
twitterStreamToDatabase = require('../modules/stream/twitterStreamToDatabase')
# updateTweet = require('../modules/stream/updateTweet')
# Export object containing all stream modules
module.exports =
  objectifyTweet: objectifyTweet
  twitter_stream: twitter_stream
  run: twitterStreamToDatabase
  # updateTweet: updateTweet