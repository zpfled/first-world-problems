// Config
var config = require('./config'),
  modules = config.modules,
  constants = config.constants,
  controllers = config.controllers,
  services = config.services,
  // Controllers
  db = controllers.db,
  routes = controllers.routes,
  stream = controllers.stream,
  // Routes
  index = routes.index,
  // Variables
  tweetsPacket = [],
  // App
  app = new modules.express(),
  http = require('http'),
  server = http.createServer(app),
  io = require('socket.io').listen(server);
  
// Setup View Engine
app.set('views', modules.path.join(__dirname, 'app/views'));
app.set('view engine', 'ejs');
app.use(modules.logger('dev'));
app.use(modules.bodyParser.json());
app.use(modules.bodyParser.urlencoded());
// app.use(cookieParser());
app.use(modules.express.static(modules.path.join(__dirname, 'app/assets')));
app.use('/', routes.index);

// Server Process
// 1. Run stream
stream.run(constants.hashtag);

// 2. Listen for connections from clients
io.sockets.on('connection', function(client) {

    var lastTweetID = 0;
    console.log('client connected...');

    // on connection, delete old tweets from db
    db.deleteOldTweets(null, function(err, success) {
      if(err) return console.error(err);
      console.log(success);
    });
    
    // on connection, get all tweets from db
    db.getAllTweetsFromDB(null, function(err, results) {
        if(err) return console.error(err);
        console.log('getting all tweets from db...');
        tweetsPacket = results;
    });

    db.getLastTweetID(function(err, id) {
        if (err) return console.error(err);
        lastTweetID = id;
    });

    // on 'ready', serve all the tweets from the db
    client.on('ready', function() {
        console.log('client ready...');
        // stream initial tweets to client
        services.streamTweetsToClient(tweetsPacket, client, constants.delay);
    });

    // periodically check db for new tweets
    client.on('moarTweets', function(id) {
        db.getNewTweets(null, lastTweetID, function(err, newTweets) {
            if(err) return console.error(err);
              newTweets.forEach(function(tweet) {
                client.emit('sendTweets', tweet);
              });

            // update lastTweetID
            db.getLastTweetID(function(err, id) {
                if (err) return console.error(err);
                lastTweetID = id;
                client.emit('lastTweet', lastTweetID);
            });
        });
        client.emit('changeColor');
    });
});


/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

server.listen(constants.port);
