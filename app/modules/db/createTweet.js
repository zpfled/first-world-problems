// Insert Tweet object into database

var dbQuery = require('./query');
var sql = require('sql');
var tweetTable = require('./schema');
var tweetSQL = sql.define({
  name: tweetTable.name,
  columns: tweetTable.columns
});

module.exports = function(tweet, cb) {
  // console.log(tweet);
  var query = tweetSQL.insert(tweet).toQuery();

  dbQuery(query, function(err, result) {

    if(err) return cb(err);

    cb(null, "tweet created");

  });
};

// TESTED =================================

if(process.argv[1] === __filename) {
    var tweetObjectToSave = {
    username: 'test',
    content: 'tweet',
    longitude: 70.5,
    latitude: 80.4,
    twitter_id: '312423',
    location: 'chicago, il',
    stars: 1
  };

  module.exports(tweetObjectToSave, function(err, data) {
      if(err) return console.error(err);
      console.log(data);
      process.reallyExit();
  });
}
