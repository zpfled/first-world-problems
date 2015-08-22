# Load Dependencies
config = require('./config')
http = require('http')
io = require('socket.io').listen(server)

# Set Variables
modules = config.modules
constants = config.constants
controllers = config.controllers
services = config.services
db = controllers.db
pages_controller = controllers.routes.pages
stream = controllers.stream
tweetsPacket = []

# Setup App
app = new (modules.express)
server = http.createServer(app)

# Setup View Engine
app.set 'views', modules.path.join(__dirname, 'app/views')
app.set 'view engine', 'ejs'
app.use modules.logger('dev')
app.use modules.bodyParser.json()
app.use modules.bodyParser.urlencoded()
app.use modules.express.static(modules.path.join(__dirname, 'app/assets'))

# Routes Config
app.use '/', pages_controller

# Server Process
# 1. Run stream
stream.run()
# 2. Listen for connections from clients
io.sockets.on 'connection', (client) ->
  lastTweetID = 0
  console.log 'client connected...'
  # on connection, delete old tweets from db
  # db.deleteOldTweets null, (err, success) ->
  #   if err
  #     return console.error(err)
  #   console.log success
  #   return
  # on connection, get all tweets from db
  db.getAllTweetsFromDB null, (err, results) ->
    if err
      return console.error(err)
    console.log 'getting all tweets from db...'
    tweetsPacket = results
    return
  db.getLastTweetID (err, id) ->
    if err
      return console.error(err)
    lastTweetID = id
    return
  # on 'ready', serve all the tweets from the db
  client.on 'ready', ->
    console.log 'client ready...'
    # stream initial tweets to client
    services.streamTweetsToClient tweetsPacket, client, constants.delay
    return
  # periodically check db for new tweets
  client.on 'moarTweets', (id) ->
    db.getNewTweets null, lastTweetID, (err, newTweets) ->
      if err
        return console.error(err)
      newTweets.forEach (tweet) ->
        client.emit 'sendTweets', tweet
        return
      # update lastTweetID
      db.getLastTweetID (err, id) ->
        if err
          return console.error(err)
        lastTweetID = id
        client.emit 'lastTweet', lastTweetID
        return
      return
    client.emit 'changeColor'
    return
  return
#/ catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return
#/ error handlers
# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err
    return
# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}
  return
server.listen constants.port