
#
# Testing rufus-decision
#
# 2007 something
#

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))

require 'rufus/decision'


module DecisionTestMixin

  protected

  def do_test (table_data, h, options, expected_result, verbose=false)

    table = Rufus::DecisionTable.new(table_data)

    if verbose
      puts
      puts "table :"
      puts table.to_csv
      puts
      puts "before :"
      puts h
    end

    h = table.transform! h, options

    if verbose
      puts
      puts "after :"
      puts h
    end

    expected_result.each do |k, v|

      value = h[k]

      value = value.join(';') if value.is_a?(Array)

      #assert \
      #  value == v,
      #  "attribute '#{k}' should be set to '#{v}' "+
      #  "but is set to '#{value}'"
      assert_equal v, value
    end
  end

end

