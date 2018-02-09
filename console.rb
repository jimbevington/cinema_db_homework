require('pry')

require_relative('./models/customer.rb')
require_relative('./models/film.rb')
require_relative('./models/ticket.rb')

Film.delete_all()
Customer.delete_all()
# don't need to delete tickets, as delete cascades from film/customerss

customer1 = Customer.new({ 'name' => 'Larry David', 'funds' => 100 })
customer2 = Customer.new({ 'name' => 'Elon Musk', 'funds' => 50 })
customer3 = Customer.new({ 'name' => 'Mahatma Gandhi', 'funds' => 250 })

customer1.save()
customer2.save()
customer3.save()

film1 = Film.new({ 'title' => 'The Human Centipede VII', 'price' => 10 })
film2 = Film.new({ 'title' => 'Cool Runnings', 'price' => 15 })
film3 = Film.new({ 'title' => 'Up', 'price' => 25 })

film1.save()
film2.save()
film3.save()

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id })
ticket2 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id })
ticket3 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film3.id })
ticket4 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id })
ticket5 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film2.id })
ticket6 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film2.id })

for ticket in [ticket1, ticket2, ticket3, ticket4, ticket5, ticket6]
  ticket.save()
end

binding.pry
nil
