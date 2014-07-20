class MemorialsTable

  def initialize(input)
    @database_connection = input
  end

  def create_new_memorial(create_memorial_hash, session_id)
    insert_memorial = <<-QUERY
      INSERT INTO memorials (name, born, died, creator_id, photo)
      VALUES ('#{create_memorial_hash[:name]}', '#{create_memorial_hash[:born]}', '#{create_memorial_hash[:died]}', #{session_id}, '#{create_memorial_hash[:photo]}')
    QUERY

    @database_connection.sql(insert_memorial)

    get_memorial_id = <<-QUERY
      SELECT id
      FROM memorials
      WHERE name = '#{create_memorial_hash[:name]}' AND born = '#{create_memorial_hash[:born]}' AND creator_id = #{session_id}
    QUERY

    memorial_id = @database_connection.sql(get_memorial_id)

    associate_user_and_memorial(session_id, memorial_id[0]["id"].to_i)
  end

  def associate_user_and_memorial(session_id, memorial_id)
    insert = <<-QUERY
      INSERT INTO users_memorials (user_id, memorial_id)
      VALUES (#{session_id}, #{memorial_id})
    QUERY

    @database_connection.sql(insert)
  end

  def all_memorials
    find_memorials = <<-QUERY
      SELECT *
      FROM memorials
    QUERY

    @database_connection.sql(find_memorials)
  end

  def memorial_by_memorial_id(memorial_id)
    find_memorial = <<-QUERY
      SELECT name, born, died, memorials.id, photo
      FROM memorials
      INNER JOIN users_memorials
      ON memorials.id = users_memorials.memorial_id
      WHERE memorials.id = #{memorial_id}
    QUERY

    memorial = @database_connection.sql(find_memorial)

    memorial.pop
  end

  def memorial_details(memorial_id)
    details = <<-QUERY
      SELECT *
      FROM memorials
      WHERE id = #{memorial_id}
    QUERY

    @database_connection.sql(details).pop
  end

end