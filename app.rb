require "sinatra"
require "active_record"
require "./lib/database_connection"
require_relative "models/app_model"

class App < Sinatra::Application
  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    erb :homepage_logged_out
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    email = params[:email]
    password = params[:password]
    database_insert_user(email, password)
    redirect "/"
  end
end
