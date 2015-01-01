require 'test/unit'
require_relative "Calendar"
require_relative "Book"

class LibraryTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @day_count = Calendar.new()
    @book1 = Book.new(1234,"East of Eden","John Steinbeck")
    @book2 = Book.new(1235,"War and Peace","Leo Tolstoy")
    @member1 = Member.new("Laura Ho",Library.new())
    @member2 = Member.new("Jamie O'Regan",Library.new())
    @lib = Library.new()
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
    assert_match("1: East of Eden, by John Steinbeck",@book1.to_s())
  end

  ## tests for Member class (:name, :library.rb, :books, :valid_library_card)

  def test_get_name
    assert_match("Laura Ho",@member1.get_name())
  end

  def test_check_out
    @member1.check_out(@book1)
    assert_equal(@book1,@member1.get_books())
  end

  def test_give_back
    @member2.check_out(@book1)
    @member2.check_out(@book2)
    @member2.give_back(@book1)
    assert_equal(@book2,@member1.get_books())
  end

  def test_get_books
    assert(@member1.get_books().empty?)
  end

  def test_send_overdue_notice
    #try using mocha to test this method?
  end

  ## tests for Library class (:library.rb, :book_collection, :calendar, :member_hash, :library_closed, :current_member)

  def test_open_raises_exception
    @lib.open()
    @lib.open()
    assert_raise(LibraryAlreadyOpenError)
  end

  def test_open_advances_calendar
    prev_day = @lib.calendar.get_date()
    @lib.open()
    assert(prev_day < @lib.calendar.get_date())
  end

  def test_open_sets_flag_to_open
    @lib.open()
    assert(@lib.library_closed == false)
  end

  def test_find_all_overdue_books_none
    assert_equal("No books are overdue.",@lib.find_all_overdue_books())
  end

  def test_find_all_overdue_books_some

    assert_equal("No books are overdue.",@lib.find_all_overdue_books())
  end

end