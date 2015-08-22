# Function that connects to and queries the database with the sql statement passed to it
pg = require('pg')
conString = process.env.DATABASE_URL or 'postgres://zpfled@localhost/fwp_dev'
console.log process.env.DATABASE_URL

module.exports = (sql, cb) ->
  pg.connect conString, (err, client, done) ->
    if err
      return console.error('error fetching client from pool', err)
    client.query sql, (err, result) ->
      #call `done()` to release the client back to the pool
      done()
      if err
        return console.error(err)
      cb null, result
      return
    return
  return

# TEST ================================
if process.argv[1] == __filename
  module.exports 'SELECT MAX("username") FROM "tweets"', (err, data) ->
    if err
      return console.error(err)
    console.log data.rows[0].max[0] == 'z'
    process.reallyExit()
    return