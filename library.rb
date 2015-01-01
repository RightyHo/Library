require "Set"

class Library
  attr :book_collection, :calendar, :member_hash, :library_open, :current_member, :filename

  def initialize()
    filename = "collection.txt"
    if File.exists?(filename)
      id = 10000
      @book_collection = Set.new()
      file = File.open(filename,r)
      while !file.eof?
        line = file.readline
        line = line[1,line.length-2]
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
  end
end