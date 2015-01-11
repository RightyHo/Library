require 'test/unit'
require 'Set'
require_relative "Calendar"
require_relative "Book"
require_relative "Member"
require_relative "Library"

class LibraryTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @lib = Library.new()
    @lib.open()
    @lib.issue_card('Wade Kelly')
    @lib.issue_card('Travis Wallach')
    @lib.issue_card('Matt Swinson')
    @lib.issue_card('Kate Edwards')
    @lib.issue_card('Cat Murdoch')
    @lib.issue_card('Amy Webb')
    @lib.issue_card('Kate Barker')

    @book1 = Book.new(1234,"East of Eden","John Steinbeck")
    @book2 = Book.new(1235,"War and Peace","Leo Tolstoy")
    @member1 = Member.new("Laura Ho",@lib)
    @member2 = Member.new("Jamie O'Regan",@lib)
    @day_count = Calendar.new()
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  ## tests for Calendar class (:day_count)

  def test_get_date
    assert_equal(0,@day_count.get_date())
  end

  def test_advance
    assert_equal(1,@day_count.advance())
  end

  ## tests for Book class (:id, :title, :author, :due_date)

  def test_get_id
    assert_equal(1234,@book1.get_id())
  end

  def test_get_title
    assert_match("East of Eden",@book1.get_title())
  end

  def test_get_author
    assert_match("John Steinbeck",@book1.get_author())
  end

  def test_get_due_date
    assert_nil(@book1.get_due_date())
  end

  def test_check_out_book
    @book1.check_out(7)
    assert_equal(7,@book1.get_due_date())
  end

  def test_check_in
    @book1.check_out(7)
    @book1.check_in()
    assert_nil(@book1.get_due_date())
  end

  def test_to_s
    assert_match("1234: East of Eden, by John Steinbeck",@book1.to_s())
  end

  ## tests for Member class (:name, :library.rb, :books, :library_card)

  def test_get_name
    assert_match("Laura Ho",@member1.get_name())
  end

  def test_check_out
    @member1.library_card = true
    expected_due_date = @lib.calendar.get_date() + 7
    @member1.check_out(@book1)
    expected = Set.new()
    expected.add(@book1)
    assert_equal(expected,@member1.get_books())
    assert_equal(expected_due_date,@book1.get_due_date())
  end

  def test_give_back
    @member2.library_card = true
    @member2.check_out(@book1)
    @member2.check_out(@book2)
    @member2.give_back(@book1)
    expected = Set.new()
    expected.add(@book2)
    assert_equal(expected,@member2.get_books())
  end

  def test_get_books
    assert(@member1.get_books().empty?)
  end

  def test_send_overdue_notice
    exception = assert_raise(ArgumentError) {@member1.send_overdue_notice(nil)}
    assert_equal('The overdue notice you are trying to send is nil.',exception.message)
  end

  ## tests for Library class (:library.rb, :book_collection, :calendar, :member_hash, :library_closed, :current_member)

  def test_library_constructor_set_up
    books_from_file = @lib.book_collection
    puts ''
    puts 'Initial library book collection:'
    books_from_file.each do |print_book|
      puts print_book.to_s()
    end
    assert_equal(1,@lib.calendar.get_date())
    assert(!@lib.member_hash.empty?)
  end

  def test_open_raises_exception
    exception = assert_raise(RuntimeError) {@lib.open()}
    assert_equal('The library is already open!',exception.message)
  end

  def test_open_advances_calendar
    prev_day = @lib.calendar.get_date()
    @lib.close()
    @lib.open()
    assert(prev_day < @lib.calendar.get_date())
  end

  def test_open_sets_flag_to_open
    @lib.close()
    @lib.open()
    assert(@lib.library_open == true)
  end

  def test_find_all_overdue_books_none
    @lib.serve('Kate Edwards')
    @lib.check_out(7,17,27)
    @lib.serve('Wade Kelly')
    @lib.check_out(34,44,54)
    @lib.serve('Cat Murdoch')
    @lib.check_out(49,59,69)
    #move forward 4 days
    @lib.close()
    @lib.open()
    @lib.close()
    @lib.open()
    @lib.close()
    @lib.open()
    @lib.close()
    @lib.open()
    puts "Expected String:  No books are overdue.  Actual String: #{@lib.find_all_overdue_books()}."
  end

  def test_find_all_overdue_books_some
    #add code
  end

  def test_issue_card
    puts ''
    puts 'Initial library member list:'
    @lib.member_hash.each do |mem_name,mem_obj|
      puts "#{mem_name} is a member of this library!"
    end
    assert_equal('Matt Swinson already has a library card.',@lib.issue_card('Matt Swinson'))
    assert_equal('Library card issued to Aaron Morgan.',@lib.issue_card('Aaron Morgan'))
    assert_equal(@lib,@lib.member_hash['Aaron Morgan'].library)
    assert_equal('Aaron Morgan',@lib.member_hash['Aaron Morgan'].get_name())
    @lib.close()
    exception = assert_raise(RuntimeError) {@lib.issue_card('Andrew Ho')}
    assert_equal('The library is not open.',exception.message)
  end

  def test_serve
    @lib.close()
    exception = assert_raise(RuntimeError) {@lib.serve('Kate Edwards')}
    assert_equal('The library is not open.',exception.message)
    @lib.open()
    assert_equal('Now serving Kate Edwards.',@lib.serve('Kate Edwards'))
    assert_equal('Linsey Simpson does not have a library card.',@lib.serve('Linsey Simpson'))
    #check that serve() prints out a list of currently checked out books to the member
    @lib.serve('Amy Webb')
    @lib.check_out(44,17,74)
    @lib.serve('Matt Swinson')
    puts "#{@lib.serve('Amy Webb')}"
  end

  def test_find_overdue_books
    #add code
  end

  def test_library_check_in
    #test exceptions are raised
    @lib.close()
    exception = assert_raise (RuntimeError){@lib.check_in(23,56)}
    assert_equal('The library is not open.',exception.message)
    @lib.open()
    exception = assert_raise (RuntimeError){@lib.check_in(23,56)}
    assert_equal('No member is currently being served.',exception.message)
    @lib.serve('Kate Barker')
    @lib.check_out(56)
    exception = assert_raise (RuntimeError){@lib.check_in(23,56)}
    assert_equal('The member does not have book 23.',exception.message)
    #test that book is returned to the library book collection, the book is set to checked in and it is removed from the members books
    book33 = nil
    @lib.book_collection.each do |book|
      if(book.get_id() == 33)
        book33 = book
      end
    end
    @lib.serve('Travis Wallach')
    @lib.check_out(33,44,55)
    assert_equal('Travis Wallach has returned 2 books.',@lib.check_in(33,44))
    exception = assert_raise (RuntimeError){@lib.check_in(33)}
    assert_equal('The member does not have book 33.',exception.message)
    assert(!@lib.current_member.get_books().include?(book33))
    assert(@lib.book_collection.include?(book33))
    assert_nil(book33.get_due_date())
  end

  def test_search
    assert_equal('Search string must contain at least four characters.',@lib.search('and'))
    assert_equal('No books found.',@lib.search('uvwxyz'))
    assert(@lib.search('Flew Over').include? "Ken Kesey")
    assert(@lib.search('joy luck').include? "The Joy Luck Club")
    puts ''
    puts "Testing search on the string - mark:"
    puts "#{@lib.search('mark')}"
    puts ''
  end

  def test_library_check_out
    #test exceptions are raised
    @lib.close()
    exception = assert_raise (RuntimeError){@lib.check_out(23,56)}
    assert_equal('The library is not open.',exception.message)
    @lib.open()
    exception = assert_raise (RuntimeError){@lib.check_out(23,56)}
    assert_equal('No member is currently being served.',exception.message)
    @lib.serve('Kate Barker')
    exception = assert_raise (RuntimeError){@lib.check_out(23,56,7777)}
    assert_equal('The library does not have book 7777.',exception.message)
    #test that book is removed from library book collection and added to the members books
    book33 = nil
    @lib.book_collection.each do |book|
      if(book.get_id() == 33)
        book33 = book
      end
    end
    @lib.serve('Travis Wallach')
    assert_equal('3 books have been checked out to Travis Wallach.',@lib.check_out(22,33,44))
    exception = assert_raise (RuntimeError){@lib.check_out(33)}
    assert_equal('The library does not have book 33.',exception.message)
    assert(@lib.current_member.get_books().include?(book33))
  end

  def test_renew
    #test exceptions are raised
    @lib.close()
    exception = assert_raise (RuntimeError){@lib.renew(23,56)}
    assert_equal('The library is not open.',exception.message)
    @lib.open()
    exception = assert_raise (RuntimeError){@lib.renew(23,56)}
    assert_equal('No member is currently being served.',exception.message)
    @lib.serve('Kate Barker')
    @lib.check_out(56)
    exception = assert_raise (RuntimeError){@lib.renew(23,56)}
    assert_equal('The member does not have book 23.',exception.message)
    #test that renewed book's due date is set to today's date plus 7
    book33 = nil
    @lib.book_collection.each do |book|
      if(book.get_id() == 33)
        book33 = book
      end
    end
    @lib.serve('Travis Wallach')
    @lib.check_out(33,44,55)
    @lib.close()
    @lib.open()
    @lib.close()
    @lib.open()
    @lib.close()
    @lib.open()
    @lib.close()
    @lib.open()
    expected_due_date = @lib.calendar.get_date() + 7
    @lib.renew(33,44)
    assert_equal(expected_due_date,book33.get_due_date())
    assert(@lib.current_member.get_books().include?(book33))
    assert(!@lib.book_collection.include?(book33))
  end

  def test_close_throws_exception
    @lib.close()
    exception = assert_raise (RuntimeError){@lib.close()}
    assert_equal('The library is not open.',exception.message)
  end

  def test_close
    assert_equal('Good night.',@lib.close())
  end

  def test_quit
    assert_equal('The library is now closed for renovations.',@lib.quit())
    assert(@lib.library_open == false)
  end

end