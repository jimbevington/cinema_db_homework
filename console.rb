require('pry')

require_relative('./models/customer.rb')
require_relative('./models/film.rb')
require_relative('./models/ticket.rb')
require_relative('./models/screening.rb')

Film.delete_all()
Customer.delete_all()
# don't need to delete tickets/screens, as delete cascades from film/customerss

customer1 = Customer.new({ 'name' => 'Larry David', 'funds' => 100 })
customer2 = Customer.new({ 'name' => 'Elon Musk', 'funds' => 50 })
customer3 = Customer.new({ 'name' => 'Mahatma Gandhi', 'funds' => 250 })
customer4 = Customer.new({ 'name' => 'Karen Dunbar', 'funds' => 175 })

customer1.save()
customer2.save()
customer3.save()
customer4.save()

film1 = Film.new({ 'title' => 'The Human Centipede VII', 'price' => 10 })
film2 = Film.new({ 'title' => 'Cool Runnings', 'price' => 15 })
film3 = Film.new({ 'title' => 'Up', 'price' => 25 })

film1.save()
film2.save()
film3.save()

screening1 = Screening.new({ 'screening_time' => '1540', 'film_id' => film1.id})
screening2 = Screening.new({ 'screening_time' => '1900', 'film_id' => film1.id})
screening3 = Screening.new({ 'screening_time' => '1300', 'film_id' => film2.id})
screening4 = Screening.new({ 'screening_time' => '2300', 'film_id' => film2.id})
screening5 = Screening.new({ 'screening_time' => '1700', 'film_id' => film3.id})

for screening in [screening1, screening2, screening3, screening4, screening5]
  screening.save()
end

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id, 'screening_id' => screening1.id })
ticket2 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film1.id, 'screening_id' => screening2.id })
ticket3 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film3.id, 'screening_id' => screening5.id })
ticket4 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id, 'screening_id' => screening3.id })
ticket5 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film2.id, 'screening_id' => screening4.id })
ticket6 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film3.id, 'screening_id' => screening5.id })
ticket7 = Ticket.new({ 'customer_id' => customer4.id, 'film_id' => film1.id, 'screening_id' => screening2.id })

for ticket in [ticket1, ticket2, ticket3, ticket4, ticket5, ticket6, ticket7]
  ticket.save()
end

binding.pry
nil

#### TO DO: films.screenings
            # add screening id to tickets
            # screening.tickets
            # do most popular screening function, most tix sold
            # limit availabe tickets per screening
