require_relative('../db/sql_runner.rb')

class Screening

  attr_reader :id
  attr_accessor :screening_time, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @screening_time = options['screening_time']
    @film_id = options['film_id']
  end

  def save
    sql = "INSERT INTO screenings (screening_time, film_id)
           VALUES ($1, $2) RETURNING id"
    values = [@screening_time, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return screenings.map{|screening| Screening.new(screening)}
  end

end
