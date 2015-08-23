# Query database for all the tweets
dbQuery = require('../../services/sql_query_service')
sql = require('sql')

module.exports = (err, cb) ->
  if err
    return cb(err)
  query = text: 'SELECT * FROM "tweets"'
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

# TESTED ===========================================
if process.argv[1] == __filename
  module.exports null, (err, results) ->
    if err
      return console.error(err)
    console.log results
    process.reallyExit()
    return