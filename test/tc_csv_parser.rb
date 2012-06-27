require 'test/unit'
require 'csv_parser'

class TestCSVParser

  # Pulled from:  http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/ruby/test/csv/test_csv.rb?rev=1.12.2.2;content-type=text%2Fplain
  def test_std_lib_csv
    [ ["\t", ["\t"]],
      ["foo,\"\"\"\"\"\",baz", ["foo", "\"\"", "baz"]],
      ["foo,\"\"\"bar\"\"\",baz", ["foo", "\"bar\"", "baz"]],
      ["\"\"\"\n\",\"\"\"\n\"", ["\"\n", "\"\n"]],
      ["foo,\"\r\n\",baz", ["foo", "\r\n", "baz"]],
      ["\"\"", [""]],
      ["foo,\"\"\"\",baz", ["foo", "\"", "baz"]],
      ["foo,\"\r.\n\",baz", ["foo", "\r.\n", "baz"]],
      ["foo,\"\r\",baz", ["foo", "\r", "baz"]],
      ["foo,\"\",baz", ["foo", "", "baz"]],
      ["\",\"", [","]],
      ["foo", ["foo"]],
      [",,", [nil, nil, nil]],
      [",", [nil, nil]],
      ["foo,\"\n\",baz", ["foo", "\n", "baz"]],
      ["foo,,baz", ["foo", nil, "baz"]],
      ["\"\"\"\r\",\"\"\"\r\"", ["\"\r", "\"\r"]],
      ["\",\",\",\"", [",", ","]],
      ["foo,bar,", ["foo", "bar", nil]],
      [",foo,bar", [nil, "foo", "bar"]],
      ["foo,bar", ["foo", "bar"]],
      [";", [";"]],
      ["\t,\t", ["\t", "\t"]],
      ["foo,\"\r\n\r\",baz", ["foo", "\r\n\r", "baz"]],
      ["foo,\"\r\n\n\",baz", ["foo", "\r\n\n", "baz"]],
      ["foo,\"foo,bar\",baz", ["foo", "foo,bar", "baz"]],
      [";,;", [";", ";"]] ].each do |csv_test|
      assert_equal(csv_test.last, FasterCSV.parse_line(csv_test.first))
    end
    
    [ ["foo,\"\"\"\"\"\",baz", ["foo", "\"\"", "baz"]],
      ["foo,\"\"\"bar\"\"\",baz", ["foo", "\"bar\"", "baz"]],
      ["foo,\"\r\n\",baz", ["foo", "\r\n", "baz"]],
      ["\"\"", [""]],
      ["foo,\"\"\"\",baz", ["foo", "\"", "baz"]],
      ["foo,\"\r.\n\",baz", ["foo", "\r.\n", "baz"]],
      ["foo,\"\r\",baz", ["foo", "\r", "baz"]],
      ["foo,\"\",baz", ["foo", "", "baz"]],
      ["foo", ["foo"]],
      [",,", [nil, nil, nil]],
      [",", [nil, nil]],
      ["foo,\"\n\",baz", ["foo", "\n", "baz"]],
      ["foo,,baz", ["foo", nil, "baz"]],
      ["foo,bar", ["foo", "bar"]],
      ["foo,\"\r\n\n\",baz", ["foo", "\r\n\n", "baz"]],
      ["foo,\"foo,bar\",baz", ["foo", "foo,bar", "baz"]] ].each do |csv_test|
      assert_equal(csv_test.last, FasterCSV.parse_line(csv_test.first))
     end
  end
  
end
