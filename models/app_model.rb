def database_insert_user(email, password)
  @database_connection.sql("INSERT INTO users (email, password) VALUES ('#{email}', '#{password}')")
end

def check_signin_set_session(email, password)
  email_pass = @database_connection.sql("SELECT email, password, id FROM users WHERE email = '#{email}'")
  p "DATA FROM QUERY #{email_pass}"
  p "EMAIL IN QUERY #{email_pass[0]["email"]}"
  p "PWRD IN QUERY #{email_pass[0]["password"]}"
  if email_pass[0]["email"] == email && email_pass[0]["password"] == password
    session[:user_id] = email_pass[0]["id"].to_i
  end
  p "SESSION SET? #{session[:user_id]}"
end