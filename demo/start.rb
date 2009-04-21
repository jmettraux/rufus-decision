
#
# just a tiny Ruby Rack application for serving the stuff under demo/
#
# start with
#
#   ruby start.rb
#
# (don't forget to
#
#   sudo gem install rack mongrel
#
# if necessary)
#

$:.unshift('lib')

require 'rubygems'
require 'rack'
require 'json'

class App
  def initialize
    @rfapp = Rack::File.new(File.dirname(__FILE__) + '/public')
  end
  def call (env)
    return decide(env) if env['PATH_INFO'] == '/decision'
    env['PATH_INFO'] = '/index.html' if env['PATH_INFO'] == '/'
    @rfapp.call(env)
  end

  def decide (env)
    json = env['rack.input'].read
    json = JSON.parse(json)
    p json.first
    p json.last
    [ 200, {}, 'toto' ]
  end
end

b = Rack::Builder.new do

  use Rack::CommonLogger
  use Rack::ShowExceptions
  run App.new
end

port = 4567

puts ".. [#{Time.now}] listening on port #{port}"

Rack::Handler::Mongrel.run(b, :Port => port) do |server|
  trap(:INT) do
    puts ".. [#{Time.now}] stopped."
    server.stop
  end
end

