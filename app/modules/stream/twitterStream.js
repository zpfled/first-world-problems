// Connect to Twitter Streaming API and return constant stream of JSON objects
var TwitterApiConnection = require('twit');

var T = new TwitterApiConnection({
  consumer_key: process.env.CONSUMER_KEY,
  consumer_secret: process.env.CONSUMER_SECRET,
  access_token: process.env.ACCESS_TOKEN,
  access_token_secret: process.env.ACCESS_TOKEN_SECRET
});

module.exports = function(hashtag, cb) {
  console.log('Firing up the Tweet Stream...tracking "' + hashtag + '".');
  var stream = T.stream('statuses/filter', {
    track: hashtag
  });

  cb(null, stream);
};