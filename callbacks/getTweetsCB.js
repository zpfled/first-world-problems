var hashtag = require('../stream/hashtag');
var filterByHashtag = require('../tasks/filterByHashtag');

module.exports = function(err, results) {
  if(err) return console.error(err);

  console.log('getting all tweets from db...');

  initialTweets = results;

  filterByHashtag(hashtag, results, function(err, filteredResults) {
    initialTweets = filteredResults;
  });
};