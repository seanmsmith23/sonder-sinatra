def database_insert_user(email, password, first, last)
  insert_user = <<-QUERY
    INSERT INTO users (firstname, lastname, email, password)
    VALUES ('#{first}', '#{last}', '#{email}', '#{password}')
  QUERY

  @database_connection.sql(insert_user)
end

def check_signin_set_session(email, password)
  user_data = <<-QUERY
    SELECT email, password, id
    FROM users
    WHERE email = '#{email}'
  QUERY

  email_pass = @database_connection.sql(user_data)

  if email_pass[0]["email"] == email && email_pass[0]["password"] == password
    session[:user_id] = email_pass[0]["id"].to_i
  end
end

def create_new_memorial(create_memorial_hash)
  insert_memorial = <<-QUERY
    INSERT INTO memorials (name, born, died, creator_id)
    VALUES ('#{create_memorial_hash[:name]}', '#{create_memorial_hash[:born]}', '#{create_memorial_hash[:died]}', #{session[:user_id]})
  QUERY

  @database_connection.sql(insert_memorial)

  get_memorial_id = <<-QUERY
    SELECT id
    FROM memorials
    WHERE name = '#{create_memorial_hash[:name]}' AND born = '#{create_memorial_hash[:born]}' AND creator_id = #{session[:user_id]}
  QUERY

  memorial_id = @database_connection.sql(get_memorial_id)

  associate_user_and_memorial = <<-QUERY
    INSERT INTO users_memorials (user_id, memorial_id)
    VALUES (#{session[:user_id]}, #{memorial_id[0]["id"].to_i})
  QUERY

  @database_connection.sql(associate_user_and_memorial)
end

def all_memorials
  find_memorials = <<-QUERY
    SELECT *
    FROM memorials
  QUERY

  @database_connection.sql(find_memorials)
end

def all_users_memorials
  find_memorials = <<-QUERY
    SELECT name, born, died, memorials.id
    FROM memorials
    INNER JOIN users_memorials
    ON memorials.id = users_memorials.memorial_id
    WHERE user_id = #{session[:user_id]}
  QUERY

  @database_connection.sql(find_memorials)
end

def memorial_by_memorial_id(memorial_id)
  find_memorial = <<-QUERY
    SELECT name, born, died, memorials.id
    FROM memorials
    INNER JOIN users_memorials
    ON memorials.id = users_memorials.memorial_id
    WHERE memorials.id = #{memorial_id}
  QUERY

  memorial = @database_connection.sql(find_memorial)

  memorial.pop
end

def have_joined(memorial_id)
  find_by_id = <<-QUERY
    SELECT *
    FROM users_memorials
    WHERE memorial_id = #{memorial_id}
  QUERY

  output = @database_connection.sql(find_by_id)

  joined = output.map { |hash| hash["user_id"].to_i }
end

def memorial_details(memorial_id)
  details = <<-QUERY
    SELECT *
    FROM memorials
    WHERE id = #{memorial_id}
  QUERY

  @database_connection.sql(details).pop
end

def join_memorial(memorial_id)
  insert = <<-QUERY
    INSERT INTO users_memorials (user_id, memorial_id)
    VALUES (#{session[:user_id]}, #{memorial_id})
  QUERY

  @database_connection.sql(insert)
end

def new_memory(memorial_id, memory)
  insert = <<-QUERY
    INSERT INTO memories (user_id, memorial_id, memory)
    VALUES (#{session[:user_id]}, #{memorial_id}, '#{memory}')
  QUERY

  @database_connection.sql(insert)
end

def all_memories(memorial_id)
  select = <<-QUERY
    SELECT users.firstname, users.lastname, memories.memory
    FROM memories
    JOIN users
    ON memories.user_id = users.id
    WHERE memorial_id = #{memorial_id}
  QUERY

  @database_connection.sql(select)
end

def check_forms_filled(email, password, path)
  if email == "" && password == ""
    flash[:error] = "Must provide username and password"
    redirect path
  elsif email == ""
    flash[:error] = "Must provide an email"
    redirect path
  elsif password == ""
    flash[:error] = "Must provide a password"
    redirect path
  end
end