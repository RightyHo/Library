class Member
  attr :name, :library, :books
  attr_accessor :library_card

  def initialize(name,library)
    @name = name
    @library = library
    @books = Set.new()
    @library_card = false
  end

  def get_name()
    return @name
  end

  def check_out(book)
    raise ArgumentError.new 'The book that you are trying to check out is nil.' if book.nil?
    if(@library_card)
      if(books.size() < 3)
        books.add(book)
      else
        puts "Error - member: #{@name} cannot check out this book because he/she has already checked out the max number of books (3)!"
      end
    else
      puts "Error - member: #{@name} cannot check out this book because he/she does not have a valid library card!"
    end
  end

  def give_back(book)
    raise ArgumentError.new 'The book that you are trying to give back is nil.' if book.nil?
    if(@books.include?(book))
      @books.delete(book)
    else
       puts 'Error - the book you are trying to give back is not currently checked out by this member'
    end
  end

  def get_books()
    return @books
  end

  def send_overdue_notice(notice)
    raise ArgumentError.new 'The overdue notice you are trying to send is nil.' if notice.nil?
    puts "#{@name}: #{notice}"
  end

end