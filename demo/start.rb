
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

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'json'
require 'sinatra'
require 'rufus/decision'

#class App
#  def initialize
#    @rfapp = Rack::File.new(File.dirname(__FILE__) + '/public')
#  end
#  def call (env)
#    return decide(env) if env['PATH_INFO'] == '/decision'
#    env['PATH_INFO'] = '/index.html' if env['PATH_INFO'] == '/'
#    @rfapp.call(env)
#  end
#  protected
#  def in_to_h (keys, values)
#    keys.inject({}) { |h, k| h[k] = values.shift; h }
#  end
#  def decide (env)
#    json = env['rack.input'].read
#    json = JSON.parse(json)
#    dt = Rufus::Decision::Table.new(json.last)
#    input = Rufus::Decision.transpose(json.first)
#      # from array of arrays to array of hashes
#    output = input.inject([]) { |a, hash| a << dt.transform(hash); a }
#    output = Rufus::Decision.transpose(output)
#      # from array of hashes to array of arrays
#    [ 200, {}, output.to_json ]
#  end
#end

use Rack::CommonLogger
use Rack::ShowExceptions

set :public, File.expand_path(File.join(File.dirname(__FILE__), 'public'))
set :views, File.expand_path(File.join(File.dirname(__FILE__), 'views'))

get '/' do

  redirect '/decision.html'
end

post '/decide' do

  json = env['rack.input'].read
  json = JSON.parse(json)

  dt = Rufus::Decision::Table.new(json.last)
  input = Rufus::Decision.transpose(json.first)
    # from array of arrays to array of hashes

  output = input.inject([]) { |a, hash| a << dt.transform(hash); a }
  output = Rufus::Decision.transpose(output)
    # from array of hashes to array of arrays

  response.headers['Content-Type'] = 'application/json'

  output.to_json
end

