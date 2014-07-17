require "sinatra"
require "active_record"
require "gschool_database_connection"
require_relative "models/app_model"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:user_id]
      erb :homepage, locals: { :memorials => all_users_memorials, :all_memorials => all_memorials }
    else
      erb :homepage_logged_out
    end
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    email = params[:email]
    password = params[:password]

    check_forms_filled(email, password, "/register")
    database_insert_user(email, password)

    redirect "/"
  end

  post "/signin" do
    email = params[:email]
    password = params[:password]
    check_forms_filled(email, password, "/")
    check_signin_set_session(email, password)
    redirect "/"
  end

  get "/logout" do
    session.delete(:user_id)
    redirect "/"
  end

  get "/create_memorial" do
    erb :create_memorial
  end

  post "/create_memorial" do
    create_memorial_hash = { creator: session[:user_id],
                             name: params[:name],
                             born: params[:born],
                             died: params[:died] }

    create_new_memorial(create_memorial_hash)

    redirect "/"
  end

  get "/memorial/:memorial_id" do
    memorial_id = params[:memorial_id]

    if session[:user_id]
      if have_joined(memorial_id).include?(session[:user_id])
        erb :memorial_page, locals: { :memorials => memorial_by_memorial_id(memorial_id),
                                      :memories => all_memories(memorial_id) }
      else
        erb :please_join, locals: { :details => memorial_details(memorial_id) }
      end
    else
      flash[:error] = "Must be logged in to view memorials"
      redirect "/"
    end
  end

  post "/join_memorial" do
    memorial_id = params[:memorial_id]
    join_memorial(memorial_id)
    redirect back
  end

  post "/new_memory" do
    memory = params[:memory]
    memorial_id = params[:memorial_id].to_i

    new_memory(memorial_id, memory) if memory && memorial_id

    flash[:new_memory] = "show_form" if params[:add_button]
    redirect back
  end
end
