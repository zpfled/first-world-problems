# Recent Tweets 1

## Learning Competencies

* Use the MVC pattern in web applications with proper allocation of code and
  responsibilities to each layer
* Incorporate third-party gems into a web application using bundler
* Extend the Sinatra application environment with a ruby gem
* Use a third-party API
* Implement OAuth

## Summary

We're going to build a simple application that fetches the most recent tweets
from a given Twitter username.

There should be two types of URLs: the index page with a URL field to enter a
Twitter username and a URL to display the most recent tweets of a particular
username.

That is,

```text
http://localhost:9393/jfarmer
```

should display the most recent tweets from https://twitter.com/jfarmer.

The goal of this challenge is to become familiar with working with third-party
APIs and the kind of architecture decisions necessary to support that.  We'll
add support for more API endpoints later.

## Releases

### Release 0: Your First Twitter Application

Add the [Twitter gem][] to your `Gemfile` and run

```text
bundle install
```

to install the Gem.  Read the **Configuration** section on the Twitter gem's
GitHub page.

You'll be using the [REST::Client](http://rdoc.info/gems/twitter/Twitter/REST/Client) for this challenge. Here's how to instantiate a new client:

```ruby
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

Note that you'll need 4 tokens to create a new client. The consumer key & secret identify are unique to the application you're building. The access token & secret are associated with a particular user.

For this challenge, the access tokens are associated with whichever user you're signed in as when you request the tokens from the Twitter developer page. So you'll be communicating with the Twitter API 'as' that user, through your Ruby application.

You'll have to register a Twitter application on Twitter and get an API key and
API secret.  You can do this at the [Twitter app registry][twitter app registry].

This will also be your first [OAuth-based application][twitter oauth].  OAuth
is a standardized authentication protocol that allows a web application to
delegate authentication to a third-party, e.g., "Log in via Twitter," "Log in
via Facebook," "Log in via Google," etc.

We won't be supporting "Log in via Twitter" yet, so when you go to create a
Twitter application the only fields that matter are the **application name**
(which must be unique across all Twitter applications) and **application
description**.  The application URL can be anything and the callback URL can be
blank.

**Note**: You'll need a callback URL in a world where you want to support "Log
in via Twitter."

After creating your application you'll be redirected to your application
configuration page.  The URL should look like

```text
https://dev.twitter.com/apps/<#application ID>/show
```

At the bottom of the page you'll see a section called **Your access token**,
which looks roughly like this:
[http://cl.ly/image/340S2F2t0V3Q](http://cl.ly/image/340S2F2t0V3Q).  Create an
access token for yourself.

You now have all the information you need to build a Twitter client.  Follow
the directions in the **configuration** section of the Twitter gem.

Here's a simple test of whether you understand how the Twitter gem and API work
and whether your environment is set up correctly.  Can you write a simple
command-line Ruby program &mdash; no more than 5-10 lines &mdash; to tweet
something from the command line on your Twitter account?

If you want to use `rake console` you'll have to `require 'twitter'` and
configure the Twitter gem in your `environment.rb` file.  While you can require
these keys directly in your environment file, this is not a good idea if you
are uploading your applications to GitHub or otherwise making this code (and
your keys) public.  To avoid this, you can put your keys in a `yaml` file and
load it in your `environment.rb` file and then put this `yaml` file in your
`.gitignore` file so you can access it locally but it will not be uploaded to
GitHub. See [this post][breakout session on api keys].

### Release 1: Recent Tweets (not cached)

Create a routes that looks like this:

```ruby
get '/' do
end

get '/:username' do
end
```

Make `/:username` display the 10 most recent tweets of the supplied Twitter
username.  Edit `environment.rb` to add the appropriate configuration.

Don't worry about leaking your development credentials into the public for now.

### Release 2: Recent Tweets (cached)

The above URL will be pretty slow.  Every time you access it you have to make
an API request, which could take a second or more.  Let's create a local cache
of the results so it's only slow the first time we get a list of recent tweets.

Create models `Tweet` and `TwitterUser`.  Implement something like the
following:

```ruby
get '/:username' do
  @user = TwitterUser.find_by_username(params[:username])
  if @user.tweets.empty?
    # User#fetch_tweets! should make an API call
    # and populate the tweets table
    #
    # Future requests should read from the tweets table
    # instead of making an API call
    @user.fetch_tweets!
  end

  @tweets = @user.tweets.limit(10)
end
```

Your code doesn't have to literally look like the code above, although the
above is a solid foundation.  You will not be penalized if you write something
different.  This will not count towards your final grade.

### Release 3: Recent Tweets (cached + invalidation)

The nice thing about the cached version is that only the first request is slow.
The bad thing about the cached version is that the list of tweets quickly
becomes stale.  If there's *any* data in the database we use that data, even if
it's two years old.

We need to flag when the cache is stale and re-fetch the data if it's stale.
Let's say for now that the cache is stale if we've fetched the recent tweets
within the last 15 minutes.  Change your controller code to work thus:

```ruby
get '/:username' do
  @user = TwitterUser.find_by_username(params[:username])
  if @user.tweets_stale?
    # User#fetch_tweets! should make an API call
    # and populate the tweets table
    #
    # Future requests should read from the tweets table
    # instead of making an API call
    @user.fetch_tweets!
  end

  @tweets = @user.tweets
end
```

The logic about what a "stale tweet" means should be in the `TwitterUser`
model.

### Release 4: Fancier Invalidation

Can you think of a better way to invalidate the cached tweets?  That is, decide
when the data is stale and needs to be re-fetched?

A famous saying goes: ["There are only two hard things in computer science:
cache invalidation and naming things."][hard things].

One issue is that every user shouldn't have their cache refreshed on the same
schedule.  Someone who tweets once a year doesn't need to have their cache
refreshed every 15 minutes.

Can you modify the `User#tweets_stale?` method to do something fancier?  Maybe
look at the average time between the last N tweets and use that as the "stale"
threshold on a per-user basis?

Think of a few possibilities and discuss the pros and cons with your pair.
Implement one.

<!-- ## Optimize Your Learning -->

## Resources

* [Register an app at twitter][twitter app registry]
* [OAuth Use with Twitter][twitter oauth]
* [More on API keys][breakout session on api keys]
* [Computer Science Witticism: Hard things][hard things]


[twitter app registry]: https://dev.twitter.com/apps/new
[twitter oauth]: https://dev.twitter.com/docs/auth/oauth/faq
[breakout session on api keys]: https://gist.github.com/dbc-challenges/c513a933644ed9ba2bc8
[hard things]: http://martinfowler.com/bliki/TwoHardThings.html
[Twitter gem]: http://rdoc.info/gems/twitter
