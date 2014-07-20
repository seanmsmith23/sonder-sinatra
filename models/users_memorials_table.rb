class UsersMemorialsTable

  def initialize(input)
    @database_connection = input
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

  def join_memorial(memorial_id, session_id)
    insert = <<-QUERY
      INSERT INTO users_memorials (user_id, memorial_id)
      VALUES (#{session_id}, #{memorial_id})
    QUERY

    @database_connection.sql(insert)
  end

  def all_users_memorials(session_id)
    find_memorials = <<-QUERY
      SELECT name, born, died, memorials.id, photo
      FROM memorials
      INNER JOIN users_memorials
      ON memorials.id = users_memorials.memorial_id
      WHERE user_id = #{session_id}
    QUERY

    @database_connection.sql(find_memorials)
  end

  def names_of_joined(memorial_id)
    select = <<-QUERY
      SELECT users.firstname, users.lastname
      FROM users_memorials
      JOIN users
      ON users_memorials.user_id = users.id
      WHERE users_memorials.memorial_id = #{memorial_id}
    QUERY

    @database_connection.sql(select)
  end

end
