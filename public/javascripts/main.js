var app = angular.module("hashtag", []);
var lastTweetID;

app.controller(
    "mapController",
    function( $scope, $interval ) {

      $interval(function(){
        $scope.tweets = window.searchArray
      }, 3000);
    }
);

$(document).ready(function () {
  var socket = window.socket;

  resetMap();
  socket.emit('ready');

  socket.on('sendTweets', function(data) {
    processTweet(data);
  });

  socket.on('lastTweet', function(id) {
    var lastTweetID = id;
  });

  socket.on('changeColor', function() {
    var index = (window.colors.index + 1) % 3;
    window.colors.darkCool = window.colors.darkCoolColors[index];
    window.colors.lightCool = window.colors.lightCoolColors[index];
    window.colors.index = index;
  });

  setInterval(askForNewTweets, 2000);

  // get moar tweets!
  function askForNewTweets() {
    socket.emit('moarTweets', lastTweetID);
  }
});
