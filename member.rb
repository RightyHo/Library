class Member
  attr :name, :library, :books, :valid_library_card

  def initialize(name,library)
    @name = name
    @library = library
    @books = Set.new()
    @valid_library_card = true
  end

  def get_name()
    return @name
  end

  def check_out(book)
    unless book.nil?
      if(@valid_library_card)
        if(books.size() < 3)
          books.add(book)
        else
          puts "Error - member: #{@name} cannot check out this book because he/she has already checked out the max number of books (3)!"
        end
      else
        puts "Error - member: #{@name} cannot check out this book because he/she does not have a valid library card!"
      end
    else
      puts 'Error - the book that you are trying to check out is NIL'
    end
  end

  def give_back(book)
    unless book.nil?
      if(@books.include?(book))
        @books.delete(book)
      else
        puts 'Error - the book you are trying to give back is not currently checked out by this member'
      end
    else
      puts 'Error - the book that you are trying to give back is NIL'
    end
  end

  def get_books()
    return @books
  end

  def send_overdue_notice(notice)
    puts "#{@name}: #{notice}"
  end
end