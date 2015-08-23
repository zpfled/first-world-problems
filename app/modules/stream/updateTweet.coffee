# update a tweet's stars field with data harvested from a retweet
dbQuery = require('../db/query')
sql = require('sql')

module.exports = (finderID, stars, cb) ->
  # `var sql`
  sql =
    text: 'UPDATE "tweets" SET "stars" = $1 WHERE "tweets"."twitter_id" = $2'
    values: [
      stars
      finderID
    ]
  dbQuery sql, (err, data) ->
    if err
      return console.error(err)
    cb null, data
    return
  return

# TEST ==============================
if process.argv[1] == __filename
  module.exports '493141255871012864', 24, (err, data) ->
    if err
      return console.error(err)
    console.log data.rowCount == 1
    process.reallyExit()
    return