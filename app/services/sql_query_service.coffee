# Dependencies
DB_URL = process.env.DATABASE_URL
Debugger = require('./debugger_service')
pg = require('pg')
q = require('q')


  # (err, client, done) ->
  #   if err
  #     return console.error('error fetching client from pool', err)
  #   client.query sql_query, (err, result) ->
  #     #call 'done()' to release the client back to the pool
  #     done()
  #     if err
  #       return console.error(err)
  #     cb null, result
  #     return
  #   return
  # return

SqlQueryService =
  # Public Methods
  query: (sql_query) ->
    deferred_query = q.defer()

    db_connection_promise = (failed_connection, client, release_client) ->
      db_connection = q.defer()
      return db_connection.reject(failed_connection) if failed_connection

      query_callback = (err, res) ->
        release_client()
        if err then db_connection.reject(err) else db_connection.resolve(res)

      client.query(sql_query, query_callback)
      return db_connection.promise

    # deferred_query.promise handlers
    success = (data) -> deferred_query.resolve(data.rows)
    fail = (error) -> deferred_query.reject(error)

    #  pg.connect(DB_URL, db_connection_promise).then(success, fail)["catch"](D
    pg.connect(DB_URL, db_connection_promise)
      .then(success, fail)
      .catch(Debugger.error)

    return deferred_query.promise

# SqlQueryService (returns a promise)
module.exports = SqlQueryService