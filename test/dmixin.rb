
#
# Testing rufus-deciision
#
# John Mettraux at openwfe.org
#
# Mon Jan 28 13:22:51 JST 2008
#

require 'rufus/decision'


module DecisionTestMixin

    protected

        def do_test (table_data, h, options, expected_result, verbose=false)

            table = Rufus::DecisionTable.new table_data

            if verbose
                puts
                puts "table :"
                puts table.to_csv
                puts
                puts "before :"
                puts wi
            end

            h = table.transform! h, options

            if verbose
                puts
                puts "after :"
                puts h
            end

            expected_result.each do |k, v|

                #if wi.attributes[k] != v
                #end

                value = h[k]

                value = value.join(';') if value.is_a?(Array)

                assert \
                    value == v,
                    "attribute '#{k}' should be set to '#{v}' "+
                    "but is set to '#{value}'"
            end
        end

end

