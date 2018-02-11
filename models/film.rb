require_relative('../db/sql_runner.rb')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save()
    sql = "INSERT INTO films (title, price)
           VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets
           ON customers.id = tickets.customer_id WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map{|customer| Customer.new(customer) }
  end

  def num_customers()
    customers = customers()
    return customers.length
  end

  def screenings()
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return screenings.map{|screening| Screening.new(screening)}
  end

  # THIS IS A VERY VERBOSE WAY OF DOING THIS, I'M SURE THERES A MORE ELEGANT
  # VERSION THAT A LESS TIRED ME COULD FIND.
  def most_popular_screening
    screenings = screenings()
    ticket_count = []
    for s in screenings
      sql = "SELECT * FROM tickets WHERE screening_id = $1"
      values = [s.id]
      result = SqlRunner.run(sql, values)
      tickets = result.map{|ticket| Ticket.new(ticket)}
      ticket_count.push(tickets.length)
    end
    # find biggest ticket count
    most_tickets = ticket_count.max
    # find index with the biggest ticket count
    most_pop_index = ticket_count.index(most_tickets)
    # return the screening at that index
    return screenings[most_pop_index]
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    films = SqlRunner.run(sql, values)
    film_array = films.map{|film| Film.new(film) }
    if film_array.length > 0
      return film_array[0]
    else
      return "Film does not exist."
    end
  end

  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map{|film| Film.new(film)}
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
