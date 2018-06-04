require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

require('pry-byebug')

Ticket.delete_all()
Screening.delete_all()
Customer.delete_all()
Film.delete_all()

cust1 = Customer.new({'name' => 'Eti', 'funds' => 100})
cust2 = Customer.new({'name' => 'Fari', 'funds' => 50})
cust3 = Customer.new({'name' => 'Zacky', 'funds' => 180})

cust1.save()
cust2.save()
cust3.save()

film1 = Film.new({'title' => 'Baahubali', 'price' => 15})
film2 = Film.new({'title' => 'Bajrangi Bhaijaan', 'price' => 12})
film3 = Film.new({'title' => 'PK', 'price' => 12})
film4 = Film.new({'title' => 'Padmavati', 'price' => 10})
film1.save()
film2.save()
film3.save()
film4.save()

price = Film.find_price_by_movie_name('PK')

# ticket1 = Ticket.new({'cust_id' => cust1.id, 'film_id' => film3.id})
# ticket2 = Ticket.new({'cust_id' => cust2.id, 'film_id' => film1.id})
# ticket3 = Ticket.new({'cust_id' => cust3.id, 'film_id' => film1.id})
# ticket4 = Ticket.new({'cust_id' => cust1.id, 'film_id' => film4.id})
# ticket5 = Ticket.new({'cust_id' => cust2.id, 'film_id' => film4.id})
# ticket6 = Ticket.new({'cust_id' => cust2.id, 'film_id' => film2.id})
# ticket1.save()
# ticket2.save()
# ticket3.save()
# ticket4.save()
# ticket5.save()
# ticket6.save()

screening1 = Screening.new({'film_id' => film1.id, 'film_time' => '15:30', 'tickets_limit' => 0})
screening2 = Screening.new({'film_id' => film2.id, 'film_time' => '18:30', 'tickets_limit' => 30})
screening3 = Screening.new({'film_id' => film3.id, 'film_time' => '21:30', 'tickets_limit' => 55})
screening1.save()
screening2.save()
screening3.save()

cust1_films = cust1.films()

film4_customers = film4.customers()

ticket1 = cust1.buy_ticket(film1, screening1)
ticket2 = cust2.buy_ticket(film1, screening2)
ticket3 = cust2.buy_ticket(film3, screening2)
ticket4 = cust3.buy_ticket(film2, screening3)
ticket5 = cust3.buy_ticket(film1, screening2)

count1 = cust1.ticket_count()
count2 = cust2.ticket_count()

cust_count = film1.count_of_customers_watching_film()

time = film1.popular_time()

cust2.cancel_ticket(ticket2)

cust = Customer.customer_with_max_funds()

binding.pry
nil
