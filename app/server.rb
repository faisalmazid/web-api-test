# server.rb
require 'sinatra'  
require 'mongoid'
require 'sinatra/namespace'
require 'sinatra/base'
require 'hola_faisalmazid'
require_relative 'book'
require_relative 'bookSerializer'

# DB Setup
Mongoid.load! "../mongoid.config"

# Endpoints
    before do
      content_type 'application/json'
    end

    helpers do
      def base_url
        @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
      end

      def json_params
        begin
          JSON.parse(request.body.read)
        rescue
          halt 400, { message:'Invalid JSON' }.to_json
        end
      end
    end

    get '/' do
      Hola_faisalmazid.hi
    end

    get '/books' do
      books = Book.all

      [:title, :isbn, :author].each do |filter|
        books = books.send(filter, params[filter]) if params[filter]
      end

      books.map { |book| BookSerializer.new(book) }.to_json
    end

    get '/books/:id' do |id|
      book = Book.where(id: id).first
      halt(404, { message:'Book Not Found'}.to_json) unless book
      BookSerializer.new(book).to_json
    end

    post '/books' do
      book = Book.new(json_params)
      if book.save
        status 201
        response.headers['Location'] = "#{base_url}/api/v1/books/#{book.id}"
      else
        status 422
        body BookSerializer.new(book).to_json
      end
    end
  
    patch '/books/:id' do |id|
      book = Book.where(id: id).first
      halt(404, { message:'Book Not Found'}.to_json) unless book
      if book.update_attributes(json_params)
        BookSerializer.new(book).to_json
      else
        status 422
        body BookSerializer.new(book).to_json
      end
    end
  
    delete '/books/:id' do |id|
      book = Book.where(id: id).first
      book.destroy if book
      status 204
    end
