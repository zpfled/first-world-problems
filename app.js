var express = require('express');
var path = require('path');
var port = process.env.PORT || 3888;
var logger = require('morgan');
// var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
// 
var pg = require('pg');
var index = require('./routes/index');

// Services
var messenger = require('./app/services/messenger');
var streamTweetsToClient = require('./app/services/streamTweetsToClient');

// DB Query Functions
var dbController = require('./app/controllers/dbController'),
  getAllTweetsFromDB = dbController.getAllTweetsFromDB,
  getNewTweets = dbController.getNewTweets,
  getLastTweetID = dbController.getLastTweetID,
  deleteOldTweets = dbController.deleteOldTweets;
console.log('dbController:');
console.log(dbController);

// Stream Functions
var streamController = require('./app/controllers/streamController'),
  objectifyTweet = streamController.objectifyTweet,
  twitterStreamToDatabase = streamController.twitterStreamToDatabase;
console.log('streamController:');
console.log(streamController);

// constants and vars
var TWEET_SENDING_DELAY = 10;
var initialTweets = [];
var tweetsToSend = [];

// SET DEFAULT HASHTAG =================================================
var hashtag = require('./app/modules/constants/hashtag');

// run stream
var runStream = twitterStreamToDatabase(hashtag);

var app = new express(),
  http = require('http'),
  server = http.createServer(app),
  io = require('socket.io').listen(server);


// view engine setup
app.set('views', path.join(__dirname, 'app/views'));
app.set('view engine', 'ejs');
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
// app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'app/assets')));
app.use('/', index);

// Server

// heroku starts the file

// listen for connections from clients
io.sockets.on('connection', function(client) {

    // hashtag = DEFAULT_HASHTAG;
    var lastTweetID = 0;
    console.log('client connected...');

    // on connection, delete old tweets from db
    deleteOldTweets(null, function(err, success) {
      if(err) return console.error(err);
      console.log(success);
    });
    
    // on connection, get all tweets from db
    getAllTweetsFromDB(null, function(err, results) {
        if(err) return console.error(err);
        console.log('getting all tweets from db...');
        initialTweets = results;
    });

    getLastTweetID(function(err, id) {
        if (err) return console.error(err);
        lastTweetID = id;
    });

    // on 'ready', serve all the tweets from the db
    client.on('ready', function() {
        console.log('client ready...');
        // stream initial tweets to client
        streamTweetsToClient(initialTweets, client, TWEET_SENDING_DELAY);
    });

    // periodically check db for new tweets
    client.on('moarTweets', function(id) {
        getNewTweets(null, lastTweetID, function(err, newTweets) {
            if(err) return console.error(err);
              newTweets.forEach(function(tweet) {
                client.emit('sendTweets', tweet);
              });

            // update lastTweetID
            getLastTweetID(function(err, id) {
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

server.listen(port);
