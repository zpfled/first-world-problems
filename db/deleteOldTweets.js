// Delete old tweets from db

var dbQuery = require('./query');
var sql = require('sql');
var getLastTweetID = require('./getLastTweetID');
var geoTweets;
var now = require('../constants/now');
var shelfLife = require('../constants/tweetShelfLife');

module.exports = function(err, cb) {
  if(err) return cb(err);

  var query = {
    text: 'DELETE FROM "tweets" WHERE ($1 - "tweets".timestamp) > $2',
    values: [ now, shelfLife ]
  };

  var results = dbQuery(query, function(err, data) {
    cb(null, data);
  });
};

// TESTED ===========================================

var cleanUp = require('./cleanUpTests');
var createTweet = require('./createTweet');

if(process.argv[1] === __filename) {


  var longTimeAgo = (now - 31);
  var stankyOldTweet = {
    username: 'test',
    content: 'so old and stanky',
    longitude: 1,
    latitude: 1,
    twitter_id: '492834573244325889',
    location: 'test',
    timestamp: longTimeAgo,
    stars: 0
  };

  createTweet(stankyOldTweet, function(err, data) {
    if(err) return console.error(err);
    if (data == 'tweet created') {
      module.exports(null, function(err, data) {
        if(err) return console.error(err);
        console.log(data.rowCount == 1);
        process.reallyExit();
      });
    }
  });
}