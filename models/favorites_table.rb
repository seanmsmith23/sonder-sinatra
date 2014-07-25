class FavoritesTable

  def initialize(input)
    @database_connection = input
  end

  def check(memory_id, user_id)
    select = <<-QUERY
      SELECT *
      FROM favorites
      WHERE memory_id = #{memory_id} AND user_id = #{user_id}
    QUERY

    @database_connection.sql(select)
  end

  def insert(memory_id, user_id)
    insert = <<-QUERY
      INSERT INTO favorites (memory_id, user_id)
      VALUES (#{memory_id}, #{user_id})
    QUERY

    @database_connection.sql(insert)
  end

  def all
    select = <<-QUERY
      SELECT *
      FROM favorites
    QUERY

    @database_connection.sql(select)
  end

  def favorites
    input = all
    memory_id = input.collect { |hash| hash["memory_id"] }

    Hash[memory_id.collect { |id| [id, memory_id.count(id)] }]
  end

end