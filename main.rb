require 'pg'
require 'pry'
require 'sinatra'
require 'httparty'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/comment'
require_relative 'models/book'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user
      return true
    else
      return false
    end
  end
end


get '/' do
  erb :index
end

get '/search_result' do
  @book= params[:book]
  result = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{@book}").parsed_response
  @search = result["items"][0]["volumeInfo"]
   # @id = result["items"][0]["volumeInfo"]["industryIdentifiers"][0]["identifier"]
  erb :search_result
end

get '/book_result' do
  book_result = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{params[:id]}").parsed_response
  #@book_search = book_result["items"][0]["volumeInfo"]

  @title = book_result["title"]
  @author = book_result["authors"]
  @publisher = book_result["publishedDate"]
  @published_date = book_result["publishedDate"]
  @description = book_result["description"]
  @page_count = book_result["pageCount"]
  @category = book_result["categories"]
  @rating = book_result["averageRating"]
  # @thumbnail = book_result["imageLinks"]["smallThumbnail"]

  erb :book_result
end

get '/about' do
  erb :about
end

get '/login' do
  erb :login
end

# post '/users' do
#   user = User.new
#   user.email = params[:email]
#   user.password = params[:password]
#   user.save
#   session[:user_id] = user.id
#   redirect '/bookshelf'
# end

get '/bookshelf' do
  #redirect '/login' unless logged_in?
  @books = Book.all.pluck(:title)
  erb :bookshelf
end

# get '/bookshelf/:id' do
#   @book = Book.find(params[:id])
#   @comments = Comment.where(book_id: params[:id])   # or @dish.id
#   erb :bookshelf
# end

post '/bookshelf' do  # add a new record
 book = Book.new
 book.title = params[:title]
 book.genre = params[:genre]
 book.author = params[:author]
 book.save
redirect '/bookshelf'
end

post '/comments' do
  comment = Comment.new
  comment.body = params[:body]
  comment.book_id = params[:book_id]
  comment.save

  redirect "/bookshelf/#{comment.book_id}"
end


get '/wishlist' do
  #redirect '/login' unless logged_in?
  erb :wishlist
end

post '/wishlist' do

end

# Handles login/logout and user sessions
post '/session' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/bookshelf'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end
