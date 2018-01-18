# require 'pg'
require 'pry'
require 'sinatra'
require 'httparty'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/comment'
require_relative 'models/book'
require_relative 'models/wish'

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
  @search = result["items"]
  erb :search_result
end

get '/book_result' do
  book_result = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{params[:id]}").parsed_response
  book_search = book_result["items"][0]["volumeInfo"]

  @title = book_search["title"]
  @author = book_search["authors"][0]
  @publisher = book_search["publisher"]
  @published_date = book_search["publishedDate"]
  @description = book_search["description"]
  @page_count = book_search["pageCount"]
  @category = book_search["categories"][0]
  @rating = book_search["averageRating"]
  @id = book_search["industryIdentifiers"][0]["identifier"]
  @thumbnail = book_search["imageLinks"]["smallThumbnail"]

  erb :book_result
end

get '/about' do
  erb :about
end

get '/login' do
  erb :login
end

post '/users' do
  user_exists = User.find_by(email: params[:email])
  if user_exists.email == params[:email]
    erb :login
  else
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  user.save
  session[:user_id] = user.id
  redirect '/bookshelf'
  end
end

get '/bookshelf' do
  #redirect '/login' unless logged_in?
  @books = Book.all.pluck(:title)
  erb :bookshelf
end

get '/bookshelf/:id' do
  @book = Book.find(params[:id])
  @comments = Comment.where(book_id: params[:id])
  erb :bookshelf
end

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

post '/wishes' do
  book_wish = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{params[:id]}").parsed_response

  wish_result = book_wish["items"][0]
  @title = wish_result["volumeInfo"]["title"]
  @genre = wish_result["volumeInfo"]["categories"][0]
  @author = wish_result["volumeInfo"]["authors"][0]
  # if wish_result["saleInfo"]["listPrice"]
  begin
    @price = wish_result["saleInfo"]["listPrice"]["amount"]
  rescue
    @price = 0
  end
  # else
    # @price = 0
  # end

  wish = Wish.new
  wish.title = @title
  wish.genre = @genre
  wish.author = @author
  wish.price = @price

  wish.save

  redirect '/'
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
