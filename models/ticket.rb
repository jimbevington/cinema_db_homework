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

  def save()
    sql = "INSERT INTO tickets (customer_id, film_id)
           VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
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
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2) WHERE id = $3"
    values = [@customer_id, @film_id, @id]
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
