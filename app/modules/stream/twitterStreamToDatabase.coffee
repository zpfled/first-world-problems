# Handles the whole process of streaming from twitter to the database

# Dependencies
twitter_stream = require('./twitter_stream')
objectifyTweet = require('./objectifyTweet')
# deprecated
dbController = require('../../controllers/dbController')
createTweet = dbController.createTweet
messenger = require('../../services/messenger')

# deprecated
objectifyCB = (err, tweetObject) ->
  if err
    return console.error(err)
  if tweetObject.username
    # createTweet tweetObject, createTweetCB
    console.log tweetObject
    tweetObject.save()
  return

# deprecated
createTweetCB = (err, data) ->
  console.log data
  return

# Return a function that, when called, starts streaming tweets to the DB
module.exports = ->
  twitter_stream.start()
  twitter_stream.on 'tweet', (tweet) ->
    objectifyTweet tweet, objectifyCB
    return