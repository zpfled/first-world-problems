# stream tweets to client on given interval

module.exports = (Tweets, Client, Delay) ->
  (->
    if Tweets.length
      Client.emit 'sendTweets', Tweets.pop()
      setTimeout streamRemainingTweets, Delay
    return
  )()
  return

# TESTED ==============================
if process.argv[1] == __filename
  messenger = require('../messenger')
  tweets = [
    'tweetle dee'
    'tweetle dum'
  ]
  module.exports tweets, messenger, 1
  messenger.on 'sendTweets', (tweet) ->
    console.log tweet == 'tweetle dee'
    process.reallyExit()
    return