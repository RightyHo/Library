require "Set"

class Library
  attr :book_collection, :calendar, :member_hash, :library_open, :current_member, :filename

  def initialize()
    #read file and make book collection
    filename = "collection.txt"
    if File.exists?(filename)
      id = 1
      @book_collection = Set.new()
      file = File.open(filename,mode="r")
      while !file.eof?
        line = file.readline
        line = line[1,line.length-3]
        split_line = line.split(",",2)
        title = split_line[0]
        author = split_line[1]
        book = Book.new(id,title,author)
        @book_collection.add(book)
        id += 1
      end
    else
      puts "Error - File: #{filename} does not exist!"
    end
    #create a calendar
    @calendar = Calendar.new()
    #create an empty dictionary of members
    @member_hash = Hash.new()
    #set library open flag to closed
    @library_open = false
    #set current member to nil
    @current_member = nil
  end

  def open()
    raise 'The library is already open!' if @library_open
    @calendar.advance()
    @library_open = true
    return "Today is day #{@calendar.get_date()}."
  end

  def find_all_overdue_books()
    raise 'This library has no members and thus has no over due books' if @member_hash.empty?
    found_overdue = false
    @member_hash.each do |name,member|
      unless member.nil?
        member.get_books().each do |book|
          if(book.get_due_date() < @calendar)
            printf "%-20s %s\n", name, book.to_s()
            found_overdue = true
          end
        end
      else
        raise 'Error - the member object you are trying to check is nil'
      end
    end
    puts 'No books are overdue.' unless found_overdue
  end

  def issue_card(name_of_member)
    raise ArgumentError.new 'The name of the member to whom you tried to issue a card was nil' if name_of_member.nil?
    raise 'The library is not open.' unless @library_open
    if @member_hash.has_key?(name_of_member)
      mem = @member_hash.fetch(name_of_member)
      if(mem.library_card)
        return "#{name_of_member} already has a library card."
      else
        mem.library_card = true
        return "Library card issued to #{name_of_member}."
      end
    else
      new_member = Member.new(name_of_member,self)    #could use Hash.store(key,value) instead.  Not sure about use of self here...is self this library object?
      new_member.library_card = true
      @member_hash[name_of_member] = new_member
      return "Library card issued to #{name_of_member}."
    end
  end

  def serve(name_of_member)
    raise ArgumentError.new 'The name of the member you tried to serve was nil' if name_of_member.nil?
    raise 'The library is not open.' unless @library_open
    if @member_hash.has_key?(name_of_member)
      mem = @member_hash.fetch(name_of_member)
      if(mem.library_card)
        @current_member = mem
        return "Now serving #{name_of_member}."
      else
        return "#{name_of_member} does not have a library card."
      end
    else
      return "#{name_of_member} does not have a library card."
    end
  end

  def find_overdue_books()
    raise 'The library is not open.' unless @library_open
    raise 'No member is currently being served.' if @current_member.nil?
    found_overdue = false
    puts "Books currently overdue for member: #{@current_member}.\n"
    @current_member.get_books().each do |book|
      if(book.get_due_date() < @calendar)
        puts "#{book.to_s()}.\n"
        found_overdue = true
      end
    end
    puts 'None.' unless found_overdue
  end

  #To check books in:
  #1. If you have not already done so, serve the member. This will print a numbered list of books checked out to that member.
  #2. check_in the books by the numbers given above.

  def check_in(*book_numbers) # * = 1..n of book numbers
    raise ArgumentError.new 'The book numbers you tried to check in were nil' if book_numbers.nil?
    raise 'The library is not open.' unless @library_open
    raise 'No member is currently being served.' if @current_member.nil?
    book_numbers.each do |bknum|
      book_found = false
      @current_member.get_books().each do |bk|
        if(bk.get_id() == bknum)
          book_found = true
          @current_member.give_back(bk)
          @book_collection.add(bk)
        end
      end
      raise "The member does not have book #{bknum}." unless book_found
    end
    return "#{@current_member.get_name()} has returned #{book_numbers.size()} books."
  end

  def search(string)
    raise ArgumentError.new 'Your search string was nil' if string.nil?

  end

  #To check books out:
  #1. If you have not already done so, serve the member. You can ignore the list of books that this will print out.
  #2. search for a book wanted by the member (unless you already know its id).
  #3. check_out zero or more books by the numbers returned from the search command.
  #4. If more books are desired, you can do another search.

  def check_out(*book_ids)  # 1..n book_ids
    raise ArgumentError.new 'The book IDs you tried to check out were nil' if book_ids.nil?
    #add code
  end

  def renew(*book_ids)  #1..n book_ids
    raise ArgumentError.new 'The book IDs you tried to renew were nil' if book_ids.nil?
    #add code
  end

  def close()
    raise 'The library is not open.' unless @library_open
    @library_open = false
    return 'Good night.'
  end

  def quit()
    @library_open = false
    return 'The library is now closed for renovations.'
  end

end