dbQuery = require('./query');

module.exports = function() {
  var cleanUpQuery = {
    text: 'DELETE FROM "tweets" WHERE "tweets".username = $1',
    values: [ "test" ]
  };

  dbQuery(cleanUpQuery, function(err, data) {
    console.log('cleaning up...');
    console.log(data.rowCount + ' rows removed.');
  });
};
