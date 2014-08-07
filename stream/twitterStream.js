// Connect to Twitter Streaming API and return constant stream of JSON objects

var Twit = require('twit');

var T = new Twit({
  consumer_key: process.env.CONSUMER_KEY,
  consumer_secret: process.env.CONSUMER_SECRET,
  access_token: process.env.ACCESS_TOKEN,
  access_token_secret: process.env.ACCESS_TOKEN_SECRET
});

module.exports = function(hashtag, cb) {
  hashtag = (typeof hashtag !== 'undefined' ? hashtag : require('./hashtag'));
  console.log('firing up the Tweet Stream...tracking ' + hashtag);
  var stream = T.stream('statuses/filter', {
    track: hashtag
  });

  cb(null, stream);
};

// CAN'T TEST THIS DIRECTLY
