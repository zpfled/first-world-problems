# Export object containing all db modules
module.exports =
  createTweet: require('./../modules/db/createTweet')
  deleteOldTweets: require('./../modules/db/deleteOldTweets')
  getAllTweetsFromDB: require('./../modules/db/getAllTweetsFromDB')
  getLastTweetID: require('./../modules/db/getLastTweetID')
  getNewTweets: require('./../modules/db/getNewTweets')
  query: require('./../services/sql_query_service')
