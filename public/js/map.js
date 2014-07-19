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

var tweetArray = [];
var lastTweet;

$(document).ready(function () {

    getTweetsFromServer();
    var load = setInterval(getTweetsFromServer, 1000);

    function getTweetsFromServer(){
        console.log('number of tweets:' + tweetArray.length)
        $.ajax({
            type: 'get',
            url: '/problems',
            dataType: 'json',
            data: {
                count: (tweetArray.length += 100)
            },
            success: function(data){
                console.log(data['length']);
                killIfNoNewTweets(data);
                cycleTweets(data);
            }
        })
    }

    function killIfNoNewTweets(data) {
        if (data['length'] === 0) {
            clearInterval(load);
        }
    }

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

    // $('.problems').on('click', function(event) {
    //     event.preventDefault();
    //     getTweetsFromServer();
    // });

    function cycleTweets(tweets) {
        console.log('cycleTweets ' + tweets);
        console.log('cycling them tweets...starting at #' + tweets.length);
        for (key in tweets) {
            createTweetObject(tweets[key], key);
        }
    }

    function createTweetObject(tweet, index) {
        console.log('createTweetObject ' + tweet);
        aTweet = new Tweet(tweet.full_text, tweet.handle, tweet.latitude , tweet.longitude, index);
        display(aTweet);
        tweetArray.push(aTweet);
    }


    function display(tweet) {
        console.log('display ' + tweet);
        L.circle([tweet.latitude, tweet.longitude], 10000, {
            color: '#484',
            fillColor: '#7b7',
            fillOpacity: 0.5
        }).addTo(map)
            .bindPopup(tweet.handle + " said:" + tweet.full_text);
    }

});
