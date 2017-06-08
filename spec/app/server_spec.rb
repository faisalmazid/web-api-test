require '././app/server.rb'
require 'rack/test'
require 'spec_helper'

set :environment, :test

RSpec.describe TodoApi do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should load the all books" do
    get '/books'
    expect(last_response.status).to eq 200
  end
  
  it "should load the specific book" do
    get '/books/59377550cbafe229b36b3ac7'
    expect(last_response.status).to eq 200
  end

  it "should load the specific book by title" do
    get '/books?title=The%20Power%20Of%20Habit'
    expect(last_response.status).to eq 200
  end
end