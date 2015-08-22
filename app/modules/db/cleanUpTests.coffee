dbQuery = require('./query')

module.exports = ->
  cleanUpQuery =
    text: 'DELETE FROM "tweets" WHERE "tweets".username = $1'
    values: [ 'test' ]
  dbQuery cleanUpQuery, (err, data) ->
    console.log 'cleaning up...'
    console.log data.rowCount + ' rows removed.'
    return
  return