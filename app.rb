# Update load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'sinatra'
require "sinatra/namespace"
require 'cognition'
require 'json'
require 'bot'

set :public_folder, __dir__ + '/public'

bot = Cognition::Bot.new
bot.register(Hello)

namespace "/api/v1" do
  before do
    # TODO: Figure out how to auth the webhook calls
    authenticate!
  end

  # Webhook payload sample
  # {
  #   "user": { "id": 1, "name": "Steve Jobs" },
  #   "room": { "id": 1, "name": "Room 1" },
  #   "message": { "id": 1, "body": { "html": "<h1>Hello world!</h1>", "plain": "Hello world!" } }
  # }
  post '/webhooks' do
    payload = JSON.parse(request.body.read)
    command = payload.dig("message", "body", "plain")
    metadata = payload.slice("user", "room")
    bot.process(command, metadata)
  end
end

get '/' do
  erb :index
end

not_found do
  'This is nowhere to be found.'
end

error do
  'Something went wrong.'
end

def authenticate!
  return true
end
