# This is our rake db:yolo. Don't do it. Unless you mean to.
# This prevents the file from being required.
if module.parent
  throw 'DON\'T YOLO THE DATABASE!'
sql = require('sql')
tweetTable = require('./schema')
tweets = sql.define(
  name: tweetTable.name
  columns: tweetTable.columns)
console.log tweets.create().toQuery().text