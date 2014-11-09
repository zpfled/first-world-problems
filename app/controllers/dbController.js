// Export object containing all db modules
module.exports = {
	cleanUpTests: require('./../modules/db/cleanUpTests'),
	createTweet: require('./../modules/db/createTweet'),
	deleteOldTweets: require('./../modules/db/deleteOldTweets'),
	getAllTweetsFromDB: require('./../modules/db/getAllTweetsFromDB'),
	getLastTweetID: require('./../modules/db/getLastTweetID'),
	getNewTweets: require('./../modules/db/getNewTweets'),
	query: require('./../modules/db/query'),
};