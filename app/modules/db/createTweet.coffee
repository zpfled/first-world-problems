# Insert Tweet object into database
dbQuery = require('./query')
sql = require('sql')
tweetTable = require('./schema')
tweetSQL = sql.define(
  name: tweetTable.name
  columns: tweetTable.columns)

module.exports = (tweet, cb) ->
  # console.log(tweet);
  query = tweetSQL.insert(tweet).toQuery()
  dbQuery query, (err, result) ->
    if err
      return cb(err)
    cb null, 'tweet created'
    return
  return

# TESTED =================================
if process.argv[1] == __filename
  tweetObjectToSave =
    username: 'test'
    content: 'tweet'
    longitude: 70.5
    latitude: 80.4
    twitter_id: '312423'
    location: 'chicago, il'
    stars: 1
  module.exports tweetObjectToSave, (err, data) ->
    if err
      return console.error(err)
    console.log data
    process.reallyExit()
    return
