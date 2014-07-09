var MAP_IMAGE_LAYER_PATTERN = 'http://{s}.tiles.mapbox.com/v3/zpfled.inakeg99/{z}/{x}/{y}.png';
// var ArrayForEach = [].forEach;
var ArrayMap = [].map;
// var tweetObjects = [];

function Tweet(full_text, handle, latitude, longitude, id) {
    this.id = id;
    this.handle = handle;
    this.full_text = full_text;
    this.latitude = latitude;
    this.longitude = longitude;
}

// Tweet.prototype.display = function() {
//     L.circle([this.latitude, this.longitude], 10000, {
//         color: '#484',
//         fillColor: '#7b7',
//         fillOpacity: 0.5
//     }).addTo(map)
//         .bindPopup(this.handle + " said:" + this.full_text)
//         .openPopup();
// };

$(document).ready(function () {
    var counter;
    var map = L.map('map', {
        center: [41.84, -87.65],
        zoom: 5,
        scrollWheelZoom: true
        // zoomControl: false
    });

    L.tileLayer(MAP_IMAGE_LAYER_PATTERN, {
        maxZoom: 18,
    }).addTo(map);

    function errorMessage(data) {
        console.log('error');
    }

    $('.problems').on('click', function(event) {
        event.preventDefault();
        $.get('/problems', cycleTweets, 'json').fail(errorMessage);
    });

    function cycleTweets(tweets) {
        console.log('cycling them tweets...starting at #' + tweets.length);
        ArrayMap.call(tweets, createTweetObject);
    }

    function createTweetObject(tweet, index) {
        aTweet = new Tweet(tweet.full_text, tweet.handle, tweet.latitude , tweet.longitude, index);
        display(aTweet);
    }


    function display(tweet) {
        L.circle([tweet.latitude, tweet.longitude], 10000, {
            color: '#484',
            fillColor: '#7b7',
            fillOpacity: 0.5
        }).addTo(map)
            .bindPopup(tweet.handle + " said:" + tweet.full_text)
            .openPopup();
    }

});
