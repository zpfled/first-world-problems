web bundle exec thin start -R config.ru -e $RACK_ENV -p $PORT
worker bundle exec sidekiq -r ./config/environment.rb
