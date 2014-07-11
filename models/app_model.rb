def database_insert_user(email, password)
  @database_connection.sql("INSERT INTO users (email, password) VALUES ('#{email}', '#{password}')")
end