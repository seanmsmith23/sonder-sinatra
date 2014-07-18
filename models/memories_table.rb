class MemoriesTable

  def initialize(input)
    @database_connection = input
  end

  def new_memory(memorial_id, memory, session_id)
    insert = <<-QUERY
      INSERT INTO memories (user_id, memorial_id, memory)
      VALUES (#{session_id}, #{memorial_id}, '#{memory}')
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

end