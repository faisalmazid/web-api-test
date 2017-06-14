require './app/server'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

describe 'Web API Service' do
  include Rack::Test::Methods

  it "should load the all books" do
    get '/books'
    expect(last_response.status).to eq 200
  end
  
  it "should load the specific book" do
    get '/books/593f9209cbafe26075bb6c91'
    expect(last_response.status).to eq 200
  end

  it "should load the specific book by title" do
    get '/books?title=The%20Power%20Of%20Habit'
    expect(last_response.status).to eq 200
  end
end
