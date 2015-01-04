class Book
  attr :id, :title, :author, :due_date

  def initialize(id,title,author)
    @id = id
    @title = title
    @author = author
    @due_date = nil
  end

  def get_id()
    return @id
  end

  def get_title()
    return @title
  end

  def get_author()
    return @author
  end

  def get_due_date()
    return @due_date
  end

  def check_out(due_date)
    raise ArgumentError.new 'The due date you are trying to set for this book is nil.' if due_date.nil?
    @due_date = due_date
  end

  def check_in()
    @due_date = nil
  end

  def to_s()
    return "#{@id}: #{@title}, by #{@author}"
  end
end