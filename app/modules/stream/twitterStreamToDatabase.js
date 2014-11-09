// Handles the whole process of streaming from twitter to the database
// require stream modules
var twitterStream = require('./twitterStream'),
  objectifyTweet = require('./objectifyTweet');
// require dbController
var dbController = require('../../controllers/dbController'),
  createTweet = dbController.createTweet;
// user messenger service
var messenger = require('../../services/messenger');
// set stream variable
var stream;

// custom callbacks
function objectifyCB(err, tweetObject) {
  if (err) return console.error(err);
  if (tweetObject.username) {
    createTweet(tweetObject, createTweetCB);
  }
}

function createTweetCB(err, data) {
  console.log(data);
}

// exports
module.exports = function(hashtag) {
  
  twitterStream(hashtag, function(err, theStream) {
    stream = theStream;
  });

  stream.on('tweet', function(tweet) {
    objectifyTweet(tweet, objectifyCB);
  });

  // memory leak risk
  messenger.on('destroy', function() {
    stream.stop();
  });
};

// CAN'T FIGURE OUT HOW TO TEST THIS DIRECTLY ====================
