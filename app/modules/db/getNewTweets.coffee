# Query database for new tweets
dbQuery = require('../db/query')
sql = require('sql')
getLastTweetID = require('./getLastTweetID')
geoTweets = undefined
# TESTED ===========================================

byID = (a, b) ->
  if a.id < b.id
    return -1
  if a.id > b.id
    return 1
  0

module.exports = (err, lastTweetID, cb) ->
  if err
    return cb(err)
  query =
    text: 'SELECT * FROM "tweets" WHERE "tweets".id > $1'
    values: [ lastTweetID ]
  results = dbQuery(query, (err, data) ->
    geoTweets = []
    data.rows.forEach (tweet) ->
      if tweet.latitude
        geoTweets.push tweet
      return
    cb null, geoTweets
    return
  )
  return

if process.argv[1] == __filename
  module.exports null, 1, (err, results) ->
    if err
      return console.error(err)
    console.log results.sort(byID)[0].id == 2
    process.reallyExit()
    return