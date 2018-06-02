require_relative("../db/sql_runner")

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save() #Create
    sql = "INSERT INTO films
    (title, price) VALUES ($1,$2)
    RETURNING id"
    values = [@title, @price]
    results = SqlRunner.run(sql,values)
    @id = results[0]['id'].to_i
  end

  def self.list_all() #Read all
    sql = "SELECT * FROM films"
    list = SqlRunner.run(sql)
    return list.map{|film| Film.new(film)}
  end

  def update() #Update
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete() #Delete
    sql = "DELETE * FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # and see which customers are coming to see one film
  # i.e list all customers by a film id
  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.cust_id WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{|cust| Customer.new(cust)}
  end

  # Check how many customers are going to watch a certain film
  def count_of_customers_watching_film()
    sql = "SELECT COUNT(*) FROM customers INNER JOIN tickets ON customers.id = tickets.cust_id WHERE tickets.film_id = $1"
    # sql = "SELECT COUNT(*) FROM tickets where film_id = $1"
    values = [@id]
    cust_count = SqlRunner.run(sql, values)
    return cust_count[0]['count'].to_i
  end

  # what is the most popular time (most tickets sold) for a given film
  def popular_time()
    sql = "SELECT film_time FROM screenings WHERE tickets_sold = (SELECT MAX(tickets_sold) FROM screenings INNER JOIN tickets ON screenings.id = tickets.screen_id WHERE tickets.film_id = $1)"
    values = [@id]
    popular_time = SqlRunner.run(sql, values)
    return popular_time[0]['film_time']
  end

  def self.delete_all() #Delete all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
