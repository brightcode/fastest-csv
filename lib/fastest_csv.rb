# This loads either csv_parser.so, csv_parser.bundle or
# csv_parser.jar, depending on your Ruby platform and OS
require 'csv_parser'
require 'stringio'

# Fast CSV parser using native code
class FastestCSV
  include Enumerable
  
  if RUBY_PLATFORM =~ /java/
    require 'jruby'
    org.brightcode.CsvParserService.new.basicLoad(JRuby.runtime)
  end

  # Pass each line of the specified +path+ as array to the provided +block+
  def self.foreach(path, &block)
    open(path) do |reader|
      reader.each(&block)
    end
  end

  # Opens a csv file. Pass a FastestCSV instance to the provided block,
  # or return it when no block is provided
  def self.open(path, mode = "rb")
    csv = new(File.open(path, mode))
    if block_given?
      begin
        yield csv
      ensure
        csv.close
      end
    else
      csv
    end
  end

  # Read all lines from the specified +path+ into an array of arrays
  def self.read(path)
    open(path, "rb") { |csv| csv.read }
  end

  # Alias for FastestCSV.read
  def self.readlines(path)
    read(path)
  end

  # Read all lines from the specified String into an array of arrays
  def self.parse(data, &block)
    csv = new(StringIO.new(data))
    if block.nil?
      begin
        csv.read
      ensure
        csv.close
      end
    else
      csv.each(&block)
    end
  end
  
  def self.parse_line(line)
    ::CsvParser.parse_line(line)
  end

  # Create new FastestCSV wrapping the specified IO object
  def initialize(io)
    @io = io
  end
  
  # Read from the wrapped IO passing each line as array to the specified block
  def each
    while row = shift
      yield row
    end
  end
  
  # Read all remaining lines from the wrapped IO into an array of arrays
  def read
    table = Array.new
    each {|row| table << row}
    table
  end
  alias_method :readlines, :read

  # Read next line from the wrapped IO and return as array or nil at EOF
  def shift
    if line = @io.gets
      ::CsvParser.parse_line(line)
    else
      nil
    end
  end
  alias_method :gets,     :shift
  alias_method :readline, :shift
  
  # Close the wrapped IO
  def close
    @io.close
  end
  
  def closed?
    @io.closed?
  end
end

class String
  # Equivalent to <tt>FasterCSV::parse_line(self)</tt>
  def parse_csv
    ::CsvParser.parse_line(self)
  end
end

