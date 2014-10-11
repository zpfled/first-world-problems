#firstWorldProblems

A Node.js app that streams tweets hashtagged with #firstWorldProblems onto a Leaflet.js map, that's searchable with Angular.js. You know, so we can see where all the real suffering in the world is going on.

##product objectives
- capture a stream of tweets from twitter
- save tweets
- display tweets on a map
- use Angular-powered search to find specific tweets and zoom in on location

##learning objectives
- Use Twitter Streaming API to collect all the tweets by hashtag
- Feed tweets to client with Node.js and Socket.io
- Use Angular.js to create dynamic, instant search in the front end

##process
I started building #firstWorldProblems because I wanted to learn how to use the Twitter API, and play around with Leaflet.js. I built it in Sinatra, initially, using the Twitter REST API to search Twitter for #firstWorldProblems tweets, then send them to the client in JSON objects containing 100 tweets each. The result was a mildly entertaining, but fairly clunky website. Page loads were slow, and you would have to refresh the page in order to see any new tweets come in.

Unsatisfied with this, I turned to Node.js. I had built something similar during my last week at Dev Bootcamp, so rebuilding #firstWorldProblems in Node was relatively easy. I switched to using the Twitter Streaming API instead of the REST API and used Socket.io to stream tweets, live, straight from Twitter onto my map. I made the map searchable with Angular.js, just for fun.

![first-world-problems.png](https://dbc-devconnect-production.s3.amazonaws.com/uploads/1407532104092/first-world-problems.png)
