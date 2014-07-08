require 'rubygems'
require 'rack/test'
require 'nokogiri'

# All our specs should require 'spec_helper' (this file)

# If RACK_ENV isn't set, set it to 'test'.  Sinatra defaults to development,
# so we have to override that unless we want to set RACK_ENV=test from the
# command line when we run rake spec.  That's tedious, so do it here.
ENV['RACK_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

module SinatraHelper
  def app
    Rack::Builder.parse_file('config.ru').first
  end
end

module NokogiriHelper
  def parsed_body
    Nokogiri::HTML(last_response.body)
  end
end

module FakeSessionHelper
  def session
    @session ||= {}
  end

  %w(get post put patch delete head).each do |request_method|
    module_eval <<-EOM
      def #{request_method}(path, params={}, env={}, &block)
        super(path, params, { 'rack.session' => session }.merge(env), &block)
        @session = last_request.env['rack.session']
      end
    EOM
  end
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include SinatraHelper
  conf.include NokogiriHelper
  conf.include FakeSessionHelper
end
