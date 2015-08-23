# Delete old tweets from db
dbQuery = require('../../services/sql_query_service')
sql = require('sql')
getLastTweetID = require('./getLastTweetID')
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