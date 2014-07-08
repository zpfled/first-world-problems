require 'twitter'

tweet = ARGV.join(" ")
# puts tweet.methods

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "2dvAY8OzwpD7HSjcY3VeyoHtw"
  config.consumer_secret     = "dUCMYe6ZCoKZEopNbW1V0r3ssdNDTnl0rtYiSrws0wrOUIc8cn"
  config.access_token        = "547150659-j1qBlT94HoU3TnRsNeFSYYIGEhkEgr0xEasfaeCp"
  config.access_token_secret = "NfcFKxSqjT8gnXoWwXPn2hCAQgmASWFQcJ2nfL1keg2jE"
end

client.search("#firstworldproblems", :result_type => "recent").collect do |tweet|
  next if Tweet.find_by_full_text(tweet.full_text)
  Tweet.create({
      full_text: tweet.full_text,
      latitude: tweet.geo.coordinates[0],
      longitude: tweet.geo.coordinates[1],
      tweeted_on: tweet.created_on
    })
end
