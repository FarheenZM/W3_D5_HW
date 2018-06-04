require_relative("../db/sql_runner")

class Customer
  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save() #Create
    sql = "INSERT INTO customers
    (name, funds) VALUES ($1,$2)
    RETURNING id"
    values = [@name, @funds]
    results = SqlRunner.run(sql,values)
    @id = results[0]['id'].to_i
  end

  def self.list_all() #Read all
    sql = "SELECT * FROM customers"
    list = SqlRunner.run(sql)
    return list.map{|customer| Customer.new(customer)}
  end

  def update() #Update
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete() #Delete
    sql = "DELETE * FROM customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  #Show which films a customer has booked to see
  #i.e list all films by a customer

  def films()
      sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE tickets.cust_id = $1"
      values = [@id]
      films = SqlRunner.run(sql, values)
      return films.map{|film| Film.new(film)}
  end

  # Buying tickets should decrease the funds of the customer by the price

  # Check that the customer has enough funds to proceed
  # If they do, create a new ticket.
  # save to database
  # Reduce the customer's funds
  # Call update() on the customer

  def buy_ticket(film_to_see, screen)
    if (@funds >= film_to_see.price) && (screen.tickets_sold < screen.tickets_limit) # Limit the available tickets for screenings.
      new_ticket = Ticket.new({'cust_id' => @id, 'film_id' => film_to_see.id, 'screen_id' => screen.id})
      new_ticket.save()
      @funds -= film_to_see.price
      update()
      screen.tickets_sold += 1 #count of tickets sold of particular screen
      screen.update()
      return new_ticket
    end
    return nil
  end

  # Check how many tickets were bought by a customer
  # list tickets by a particular customer
  # count no. of tickets
  def ticket_count()
    sql = "SELECT COUNT(*) FROM tickets WHERE cust_id = $1"
    values = [@id]
    count = SqlRunner.run(sql, values)
    return count[0]['count'].to_i
  end

  # To cancel a booked ticket
  # delete ticket by ticket id
  # refund cust i.e increase cust funds
  # decrease tickets_sold
  def cancel_ticket(ticket)

    sql = "SELECT film_id FROM tickets WHERE id = $1"
    values = [ticket.id]
    film_id = SqlRunner.run(sql, values)[0]['film_id']

    sql = "SELECT price FROM films WHERE id = $1"
    values = [film_id]
    price = SqlRunner.run(sql, values)[0]['price'].to_i
    @funds += price
    update()


    sql = "SELECT screen_id FROM tickets WHERE id = $1"
    values = [ticket.id]
    screen_id = SqlRunner.run(sql, values)[0]['screen_id']

    sql = "SELECT tickets_sold FROM screenings WHERE id = $1"
    values = [screen_id]
    tickets_sold = SqlRunner.run(sql, values)[0]['tickets_sold'].to_i
    tickets_sold -= 1
    sql = "UPDATE screenings SET tickets_sold = $1 WHERE id = $2"
    values = [tickets_sold, screen_id]
    SqlRunner.run(sql, values)


    sql = "Delete FROM tickets WHERE id = $1"
    values = [ticket.id]
    SqlRunner.run(sql, values)

  end

  def self.customer_with_max_funds()  # Sorting ; for PDA
    sql = "SELECT * FROM customers ORDER BY funds DESC"
    results = SqlRunner.run(sql)
    cust_name = results[0]['name']
    return cust_name
  end

  def self.delete_all() #Delete all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end
