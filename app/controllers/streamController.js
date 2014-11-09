// Set variables
var objectifyTweet = require('../modules/stream/objectifyTweet'),
	twitterStream = require('../modules/stream/twitterStream'),
	twitterStreamToDatabase = require('../modules/stream/twitterStreamToDatabase'),
	updateTweet = require('../modules/stream/updateTweet');

// Export object containing all stream modules
module.exports = {
	objectifyTweet: objectifyTweet,
	twitterStream: twitterStream,
	twitterStreamToDatabase: twitterStreamToDatabase,
	updateTweet: updateTweet
};