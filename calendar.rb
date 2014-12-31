class Calendar
  attr :day_count

  def initialize()
    @day_count = 0
  end

  def get_date()
    return @day_count
  end

  def advance()
    return @day_count += 1
  end

end

