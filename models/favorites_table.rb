class FavoritesTable

  def initialize(database_class)
    @database_connection = database_class
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
    memory_id = all.collect { |hash| hash["memory_id"] }

    Hash[memory_id.collect { |id| [id, memory_id.count(id)] }]
  end

  def memories_sorted_by_favorites(memories_array)
    output = []

    p "memory array"
    p memories_array
    p "favorites"
    p favorites
    p "all"
    p all

    memories_array.each do |memory|
      favorites.each do |key, value|
        if key == memory["id"]
          output << memory.merge({"favorites" => value } )
          break
        elsif favorites.to_a.flatten[-2] == key && favorites.to_a.flatten[-1] == value
          output << memory.merge({"favorites" => "0" } )
        end
      end
    end

    sorted = output.sort_by { |memory| memory["favorites"].to_i }.reverse

    sorted
  end

end