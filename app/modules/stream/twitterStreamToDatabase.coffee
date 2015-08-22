# Handles the whole process of streaming from twitter to the database
# require stream modules
twitterStream = require('./twitterStream')
objectifyTweet = require('./objectifyTweet')
# require dbController
dbController = require('../../controllers/dbController')
createTweet = dbController.createTweet
# user messenger service
messenger = require('../../services/messenger')
# set stream variable
stream = undefined
# exports
# custom callbacks

objectifyCB = (err, tweetObject) ->
  if err
    return console.error(err)
  if tweetObject.username
    createTweet tweetObject, createTweetCB
  return

createTweetCB = (err, data) ->
  console.log data
  return

module.exports = (hashtag) ->
  twitterStream hashtag, (err, theStream) ->
    stream = theStream
    return
  stream.on 'tweet', (tweet) ->
    objectifyTweet tweet, objectifyCB
    return
  # memory leak risk
  messenger.on 'destroy', ->
    stream.stop()
    return
  return