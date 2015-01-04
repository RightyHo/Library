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
    @member1.check_out(@book1)
    expected = Set.new()
    expected.add(@book1)
    assert_equal(expected,@member1.get_books())
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
    #try using mocha to test this method?
  end

  ## tests for Library class (:library.rb, :book_collection, :calendar, :member_hash, :library_closed, :current_member)

  def test_library_constructor_set_up
    books_from_file = @lib.book_collection
    books_from_file.each do |print_book|
      puts print_book.to_s()
    end
    puts "Calendar date set to: #{@lib.calendar.get_date()}"
    puts 'An empty member hash dictionary has been set up' if @lib.member_hash.empty?
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
    #add code
    @lib.find_all_overdue_books()
  end

  def test_find_all_overdue_books_some
    #add code
  end

  def test_issue_card
    @lib.member_hash.each do |mem_name,mem_obj|
      puts "#{mem_name} is a member of this library!"
    end
    assert_equal('Matt Swinson already has a library card.',@lib.issue_card('Matt Swinson'))
    assert_equal('Library card issued to Aaron Morgan.',@lib.issue_card('Aaron Morgan'))
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
  end
end