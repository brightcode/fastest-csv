require 'csv_parser'

class FastestCSV
  
  # This method opens an accounting file and passes each record to the provided +block+.
  def self.foreach(path, &block)
    open(path) do |reader|
      reader.each(&block)
    end
  end

  # This method opens a csv file. It will pass a Reader object to the provided block,
  # or return a Reader object when no block is provided.
  def self.open(path)
    reader = new(File.open(path, 'r'))
    if block_given?
      begin
        yield reader
      ensure
        reader.close
      end
    else
      reader
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
end
