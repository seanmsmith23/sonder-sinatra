require "rack-flash"

class UsersTable

  def initialize(input)
    @database_connection = input
  end

  def database_insert_user(email, password, first, last)
    insert_user = <<-QUERY
      INSERT INTO users (firstname, lastname, email, password)
      VALUES ('#{first}', '#{last}', '#{email}', '#{password}')
    QUERY

    @database_connection.sql(insert_user)
  end

  def check_signin_get_id(email, password)
    user_data = <<-QUERY
      SELECT email, password, id
      FROM users
      WHERE email = '#{email}'
    QUERY

    email_pass = @database_connection.sql(user_data).pop

    if email == "" or password == ""
      error = "Please provide a username and password"
    elsif email_pass == nil
      error = "Username/password combination not found"
    elsif email_pass["email"] == email && email_pass["password"] == password
      email_pass["id"].to_i
    else
      error = "Something went wrong, please try again"
    end
  end

  # def form_has_errors(first="nothing", last="nothing", email, password)
  #   if first == ""
  #     error = "Must provide first name"
  #   elsif last == ""
  #     error = "Must provide last name"
  #   elsif email == ""
  #     error = "Must provide an email"
  #   elsif password == ""
  #     error = "Must provide a password"
  #   else
  #     error = nil
  #   end
  # end

end