# Insert Tweet object into database
db = require('../../services/sql_query_service')
Tweet = require('../../models/tweet')
sql = require('sql')

module.exports = (tweet, cb) ->
  console.log 'in CREATE:', tweet
  query = sql.define(Tweet.schema()).insert(tweet).toQuery()
  db.query query, (err, result) ->
    if err
      return cb(err)
    cb null, 'tweet created'
    return
  return

# # TESTED =================================
# if process.argv[1] == __filename
#   tweetObjectToSave =
#     username: 'test'
#     content: 'tweet'
#     longitude: 70.5
#     latitude: 80.4
#     twitter_id: '312423'
#     location: 'chicago, il'
#     stars: 1
#   module.exports tweetObjectToSave, (err, data) ->
#     if err
#       return console.error(err)
#     console.log data
#     process.reallyExit()
#     return
