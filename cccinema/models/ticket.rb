require_relative("../db/sql_runner")

class Ticket
  attr_reader :id
  attr_accessor :cust_id, :film_id, :screen_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @cust_id = options['cust_id'].to_i
    @film_id = options['film_id'].to_i
    @screen_id = options['screen_id'].to_i
  end

  def save() #Create
    sql = "INSERT INTO tickets
    (cust_id, film_id, screen_id) VALUES ($1,$2,$3)
    RETURNING id"
    values = [@cust_id, @film_id, @screen_id]
    results = SqlRunner.run(sql,values)
    @id = results[0]['id'].to_i
  end

  def self.list_all() #Read all
    sql = "SELECT * FROM tickets"
    list = SqlRunner.run(sql)
    return list.map{|ticket| Ticket.new(ticket)}
  end

  def update() #Update
    sql = "UPDATE tickets SET (cust_id, film_id, screen_id) = ($1, $2, $3) WHERE id = $4"
    values = [@cust_id, @film_id, @screen_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete() #Delete
    sql = "DELETE * FROM tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end
  

  def self.delete_all() #Delete all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end
