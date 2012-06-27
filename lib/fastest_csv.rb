require 'csv_parser'
require 'stringio'

class FastestCSV
  
  # This method opens an accounting file and passes each record to the provided +block+.
  def self.foreach(path, &block)
    open(path) do |reader|
      reader.each(&block)
    end
  end

  # This method opens a csv file. It will pass a Reader object to the provided block,
  # or return a Reader object when no block is provided.
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

  def self.read(path)
    open(path, "rb") { |csv| csv.read }
  end

  def self.readlines(path)
    read(path)
  end

  def self.parse(data, &block)
    csv = new(StringIO.new(data))
    if block.nil?  # slurp contents, if no block is given
      begin
        csv.read
      ensure
        csv.close
      end
    else           # or pass each row to a provided block
      csv.each(&block)
    end
  end

  def initialize(io)
    @io = io
  end
  
  def each
    while row = shift
      yield row
    end
  end
  
  def read
    table = Array.new
    each {|row| table << row}
    table
  end
  alias_method :readlines, :read

  def shift
    if line = @io.gets
      FastestCSV.parse_line(line)
    else
      nil
    end
  end
  alias_method :gets,     :shift
  alias_method :readline, :shift
  
  def close
    @io.close
  end
  
  def closed?
    @io.closed?
  end
end

class String
  # Equivalent to <tt>FasterCSV::parse_line(self, options)</tt>.
  def parse_csv
    FastestCSV.parse_line(self)
  end
end

