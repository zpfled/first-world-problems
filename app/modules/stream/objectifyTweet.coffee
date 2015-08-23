# turn tweet json from stream into a js object in the format we want
date = require('../constants/now')
Tweet = require('../../models/tweet')
# updateTweet = require('./updateTweet')

module.exports = (tweet, cb) ->
  dbTweet = {}
  if tweet.retweeted_status
    # console.log 'updating a tweet...'
    finderID = tweet.retweeted_status.id_str
    retweets = tweet.retweeted_status.retweet_count
    favorites = tweet.retweeted_status.favorite_count
    stars = retweets + favorites
    # console.log finderID
    # console.log 'stars: ' + stars
    # updateTweet finderID, stars, (err, data) ->
    #   if err
    #     return console.error(err)
    #   # console.log(data.rowCount === 1);
    #   return
  if tweet.coordinates
    # console.log tweet
    console.log "Tweet::", Tweet().new(tweet)
    dbTweet = Tweet().new(tweet)
    console.log '======================================='
    console.log 'dbTweet', dbTweet
  cb null, dbTweet
  return

# TESTED =========================================
# if process.argv[1] == __filename
#   rawTweet =
#     created_at: 'Sat Jul 26 00:51:33 +0000 2014'
#     id: 492834573244325900
#     id_str: '492834573244325889'
#     text: 'Why Do Americans Stink At Math? http://t.co/21o8inbmSV by @nytimes #umanopicks #didyouknow #science @umanoapp'
#     source: '<a href="http://www.apple.com" rel="nofollow">iOS</a>'
#     truncated: false
#     in_reply_to_status_id: null
#     in_reply_to_status_id_str: null
#     in_reply_to_user_id: null
#     in_reply_to_user_id_str: null
#     in_reply_to_screen_name: null
#     user:
#       id: 75381887
#       id_str: '75381887'
#       name: 'Jeffrey Guity'
#       screen_name: 'jeffguity'
#       location: ''
#       url: null
#       description: 'There\'s always money in the banana stand!\n\n#Yankees #Lakers #Patriots fan'
#       protected: false
#       verified: false
#       followers_count: 186
#       friends_count: 1744
#       listed_count: 2
#       favourites_count: 2548
#       statuses_count: 11314
#       created_at: 'Fri Sep 18 20:48:36 +0000 2009'
#       utc_offset: -14400
#       time_zone: 'Eastern Time (US & Canada)'
#       geo_enabled: true
#       lang: 'en'
#       contributors_enabled: false
#       is_translator: false
#       profile_background_color: '022330'
#       profile_background_image_url: 'http://pbs.twimg.com/profile_background_images/46379682/yankees.jpg'
#       profile_background_image_url_https: 'https://pbs.twimg.com/profile_background_images/46379682/yankees.jpg'
#       profile_background_tile: false
#       profile_link_color: '0084B4'
#       profile_sidebar_border_color: 'A8C7F7'
#       profile_sidebar_fill_color: 'C0DFEC'
#       profile_text_color: '333333'
#       profile_use_background_image: true
#       profile_image_url: 'http://pbs.twimg.com/profile_images/415138175041150976/eIoeJjQV_normal.jpeg'
#       profile_image_url_https: 'https://pbs.twimg.com/profile_images/415138175041150976/eIoeJjQV_normal.jpeg'
#       profile_banner_url: 'https://pbs.twimg.com/profile_banners/75381887/1405097168'
#       default_profile: false
#       default_profile_image: false
#       following: null
#       follow_request_sent: null
#       notifications: null
#     geo: null
#     coordinates: coordinates: [
#       1
#       1
#     ]
#     place: null
#     contributors: null
#     retweet_count: 0
#     favorite_count: 0
#     entities:
#       hashtags: [
#         [ Object ]
#         [ Object ]
#         [ Object ]
#       ]
#       trends: []
#       urls: [ [ Object ] ]
#       user_mentions: [
#         [ Object ]
#         [ Object ]
#       ]
#       symbols: []
#     favorited: false
#     retweeted: false
#     possibly_sensitive: false
#     filter_level: 'medium'
#     lang: 'en'
#   module.exports rawTweet, (err, data) ->
#     if err
#       return console.error(err)
#     console.log 'dbTweet:'
#     console.log data
#     return