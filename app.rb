require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require_relative "models/users_table"
require_relative "models/users_memorials_table"
require_relative "models/memorials_table"
require_relative "models/memories_table"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @users_table = UsersTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @memorials_table = MemorialsTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @users_memorials_table = UsersMemorialsTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @memories_table = MemoriesTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
  end

  get "/" do
    if session[:user_id]
      erb :homepage, locals: { :memorials => @users_memorials_table.all_users_memorials(session[:user_id])}
    else
      erb :homepage_logged_out
    end
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    first = params[:first]
    last = params[:last]
    email = params[:email]
    password = params[:password]

    @users_table.database_insert_user(email, password, first, last)

    redirect "/"
  end

  post "/signin" do
    email = params[:email]
    password = params[:password]

    checked_login = @users_table.check_signin_get_id(email, password)

    if checked_login.is_a?(Integer)
      session[:user_id] = checked_login
    else
      # returns error message
      checked_login
    end

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
                             died: params[:died],
                             photo: params[:photo] }

    @memorials_table.create_new_memorial(create_memorial_hash, session[:user_id])

    redirect "/"
  end

  get "/memorials/find" do
    erb :memorial_find, locals: { :all_memorials => @memorials_table.all_memorials }
  end

  get "/memorial/:memorial_id" do
    memorial_id = params[:memorial_id]

    if session[:user_id]
      if @users_memorials_table.have_joined(memorial_id).include?(session[:user_id])
        erb :memorial_page, locals: { :memorials => @memorials_table.memorial_by_memorial_id(memorial_id),
                                      :memories => @memories_table.all_memories(memorial_id) }
      else
        erb :please_join, locals: { :details => @memorials_table.memorial_details(memorial_id) }
      end
    else
      flash[:error] = "Must be logged in to view memorials"
      redirect "/"
    end
  end

  get "/memorial/:memorial_id/members" do
    memorial_id = params[:memorial_id].to_i
    names_from_db = @users_memorials_table.names_of_joined(memorial_id)

    erb :memorial_members, locals: { :names => names_from_db }
  end

  post "/join_memorial" do
    memorial_id = params[:memorial_id]
    @users_memorials_table.join_memorial(memorial_id, session[:user_id])
    redirect back
  end

  post "/new_memory" do
    memory = params[:memory]
    memorial_id = params[:memorial_id].to_i

    @memories_table.new_memory(memorial_id, memory, session[:user_id]) if memory && memorial_id

    flash[:new_memory] = "show_form" if params[:add_button]
    redirect back
  end
end
