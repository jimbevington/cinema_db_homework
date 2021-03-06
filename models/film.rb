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

  def most_popular_screening
    # create some empty vars
    most_popular_indices = []
    most_popular_screenings = []
    ticket_count = []
    # get all the screening objects for that film
    screenings = screenings()
    # fill ticket_count with number of ticket
    for s in screenings
      sql = "SELECT * FROM tickets WHERE screening_id = $1"
      values = [s.id]
      result = SqlRunner.run(sql, values)
      tickets = result.map{|ticket| Ticket.new(ticket)}
      ticket_count.push(tickets.length)
    end
    # find biggest ticket count
    most_tickets = ticket_count.max
    count = 0
    for num in ticket_count
      if num == most_tickets
        most_popular_indices.push(count)
        count += 1
      end
    end
    # find index with the biggest ticket count
    for ind in most_popular_indices
      most_popular_screenings.push(screenings[ind])
    end
    return most_popular_screenings
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
