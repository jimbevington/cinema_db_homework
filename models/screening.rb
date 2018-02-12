require_relative('../db/sql_runner.rb')

class Screening

  attr_reader :id
  attr_accessor :screening_time, :film_id, :tickets_available

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @screening_time = options['screening_time']
    @film_id = options['film_id']
    @tickets_available = options['tickets_available']
  end

  def save
    sql = "INSERT INTO screenings (screening_time, film_id, tickets_available)
           VALUES ($1, $2, $3) RETURNING id"
    values = [@screening_time, @film_id, @tickets_available]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (screening_time, film_id, tickets_available) = ($1, $2, $3)
           WHERE id = $4"
    values = [@screening_time, @film_id, @tickets_available, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def tickets()
    sql = "SELECT * FROM tickets WHERE screening_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map{|ticket| Ticket.new(ticket)}
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return screenings.map{|screening| Screening.new(screening)}
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
