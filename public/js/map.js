$(document).ready(function() {
    var counter, tweet, marker;
    var map = L.map('map', {
        center: [41.84, -87.65],
        zoom: 5,
        scrollWheelZoom: false
        // zoomControl: false
    });

    L.tileLayer('http://{s}.tiles.mapbox.com/v3/zpfled.inakeg99/{z}/{x}/{y}.png', {
        // attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
        maxZoom: 18,
    }).addTo(map);


    $('.problems').on('click', function(event) {
        event.preventDefault();

        $.ajax({
            url: '/problems',
            method: 'GET',
            type: 'json',
            success: function(data) {
                console.log('success');
                console.log(data);
                cycleTweets(data)
            },
            error: function(data) {
                console.log('error');
                console.log(data);
            }
        })
    })

    function cycleTweets(data) {
        console.log('cycling them tweets...starting at #' + data['count']);
        for (counter = 1; counter < data['count']; counter++) {
            addMarker(data[counter], counter);
        }
    }

    function addMarker(tweet, idNumber) {
        console.log(tweet)
        idNumber = L.circle([tweet['latitude'], tweet['longitude']], 10000, {
            color: '#484',
            fillColor: '#7b7',
            fillOpacity: 0.5
        }).addTo(map)
            .bindPopup(tweet['full_text'])
            .openPopup();;
    }

});
