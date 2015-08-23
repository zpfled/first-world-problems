# This is our rake db:yolo. Don't do it. Unless you mean to.
# This prevents the file from being required.
if module.parent
  throw 'DON\'T YOLO THE DATABASE!'
sql = require('sql')
Tweet = require('../../models/tweet')
tweets = sql.define(Tweet.schema())
console.log tweets.create().toQuery().text