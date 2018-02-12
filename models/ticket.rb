require_relative('../db/sql_runner.rb')

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id']
    @film_id = options['film_id']
    @screening_id = options['screening_id']
  end

  # return true or false
  def check_availability
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@screening_id]
    result = SqlRunner.run(sql, values)
    screenings = result.map{|ticket| Screening.new(ticket)}
    return screenings[0].tickets_available.to_i > 0
  end

  def reduce_available_tickets
    sql = "UPDATE screenings SET tickets_available = (tickets_available -1)
           WHERE id = $1"
    values = [@screening_id]
    SqlRunner.run(sql, values)
  end

  def save()
    if check_availability() # if there are tickets available
      sql = "INSERT INTO tickets (customer_id, film_id, screening_id)
             VALUES ($1, $2, $3) RETURNING id"
      values = [@customer_id, @film_id, @screening_id]
      @id = SqlRunner.run(sql, values)[0]['id'].to_i
      # take ticket away from Screenings available tickets
      reduce_available_tickets()
    else
      
      return "No tickets available."
    end
  end

  # RETURN film's price for UPDATE_CUSTOMER_FUNDS() below
  def get_film_price
    sql = "SELECT price FROM films WHERE id = $1"
    values = [@film_id]
    price = SqlRunner.run(sql, values)[0]['price']
    return price.to_i
  end

  def update_customer_funds
    deduction = get_film_price()
    sql = "UPDATE customers SET funds = (funds - $1) WHERE id = $2"
    values = [deduction, @customer_id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE tickets SET (customer_id, film_id, screening_id) = ($1, $2, $3) WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    tickets = SqlRunner.run(sql, values)
    ticket_array = tickets.map{|ticket| Ticket.new(ticket) }
    if ticket_array.length > 0
      return ticket_array[0]
    else
      return "Ticket does not exist"
    end
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return tickets.map{|ticket| Ticket.new(ticket)}
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end
