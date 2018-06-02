require_relative("../db/sql_runner")

class Screening
  attr_reader :id
  attr_accessor :film_id, :film_time, :tickets_sold, :tickets_limit

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @film_time = options['film_time']
    @tickets_sold = 0
    @tickets_limit = options['tickets_limit']   # Limit the available tickets for screenings.
  end

  def save()
    sql = "INSERT INTO screenings
    (film_id, film_time, tickets_sold, tickets_limit) VALUES ($1, $2, $3, $4) RETURNING id"
    values = [@film_id, @film_time, @tickets_sold, @tickets_limit]
    results = SqlRunner.run(sql,values)
    @id = results[0]['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (film_id, film_time, tickets_sold, tickets_limit) = ($1, $2, $3, $4) WHERE id = $5"
    values = [@film_id, @film_time, @tickets_sold, @tickets_limit, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
