# return an Integer equal to id of last tweet in db
dbQuery = require('./query')
sql = require('sql')
lastTweet = undefined

module.exports = (cb) ->
  `var sql`
  sql = text: 'SELECT MAX("id") FROM "tweets"'
  lastTweet = dbQuery(sql, (err, data) ->
    if err
      return console.error(err)
    cb null, data.rows[0].max
    return
  )
  return

# TESTED ==============================
if process.argv[1] == __filename
  module.exports (err, lastTweetID) ->
    if err
      return console.error(err)
    console.log lastTweetID
    process.reallyExit()
    return