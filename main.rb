require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'pg'


get '/' do
  erb :index
end

get '/search_result' do
  @title = params[:title]
  result = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{@title}").parsed_response
  @search = result["items"][0]["volumeInfo"]
  erb :search_result
end

get '/book_result' do
  book_result = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{@id}").parsed_response
  @id = result["items"][0]["volumeInfo"]["industryIdentifiers"][0]["identifier"]
  @book_search = book_result["items"][0]["volumeInfo"]

  @title = book_result["title"]
  @author = book_result["authors"]
  @publisher = book_result["publishedDate"]
  @published_date = book_result["publishedDate"]
  @description = book_result["description"]
  @page_count = book_result["pageCount"]
  @category = book_result["categories"]
  @rating = book_result["averageRating"]
  @thumbnail = book_result["imageLinks"]["smallThumbnail"]

  erb :book_result
end

get '/about' do
  erb :about
end
