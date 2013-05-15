
#
# testing rufus-decision
#
# 2007 something
#

require 'test/unit'
require 'rufus/decision'


def trim_table(s)

  s.split("\n").collect(&:lstrip).join("\n").strip
end


module DecisionTestMixin

  protected

  def do_test(table_data, h, expected_result, verbose=false)

    table =
      if table_data.is_a?(Rufus::Decision::Table)
        table_data
      else
        Rufus::Decision::Table.new(table_data)
      end

    if verbose
      puts
      puts 'table :'
      puts table.to_csv
      puts
      puts 'before :'
      p h
    end

    h = table.transform!(h)

    if verbose
      puts
      puts 'after :'
      p h
    end

    expected_result.each do |k, v|

      value = h[k]

      value = value.join(';') if value.is_a?(Array)

      assert_equal v, value
    end
  end
end

