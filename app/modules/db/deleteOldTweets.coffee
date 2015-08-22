# Delete old tweets from db
dbQuery = require('./query')
sql = require('sql')
getLastTweetID = require('./getLastTweetID')
geoTweets = undefined
now = require('../constants/now')
shelfLife = require('../constants/tweetShelfLife')

module.exports = (err, cb) ->
  if err
    return cb(err)
  query =
    text: 'DELETE FROM "tweets" WHERE ($1 - "tweets".timestamp) > $2'
    values: [
      now
      shelfLife
    ]
  results = dbQuery(query, (err, results) ->
    cb null, results
    return
  )
  return

# TESTED ===========================================
cleanUp = require('./cleanUpTests')
createTweet = require('./createTweet')
if process.argv[1] == __filename
  longTimeAgo = now - 31
  stankyOldTweet =
    username: 'test'
    content: 'so old and stanky'
    longitude: 1
    latitude: 1
    twitter_id: '492834573244325889'
    location: 'test'
    timestamp: longTimeAgo
    stars: 0
  createTweet stankyOldTweet, (err, data) ->
    if err
      return console.error(err)
    if data == 'tweet created'
      module.exports null, (err, data) ->
        if err
          return console.error(err)
        console.log data.rowCount == 1
        process.reallyExit()
        return
    return
