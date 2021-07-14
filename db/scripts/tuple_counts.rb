# run from the command line with:  rails runner -e development db/scripts/tuple_counts.rb

# that's an integer
def check_table_has_id_column(table_name, connection)
  sql = "SELECT count(1)
           FROM information_schema.columns
           WHERE table_schema = 'public'
             AND column_name = 'id'
             AND table_name = '#{table_name}'"
  result = connection.execute(sql).values.flatten.join.to_i
  !(result == 0)
end

def check_table_count(table_name, connection, class_name) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  # get count of records in table. set to count empty string if result == 0.
  sql = "select count(1) from #{table_name}"
  result = connection.execute(sql).values.flatten.join.to_i
  count = if result == 0
    "   "
  else
    result
  end

  # get value of highest id in table. set to "na" if result == 0.
  sql = "select max(id) from #{table_name};"
  result = connection.execute(sql).values.flatten.join.to_i
  max_id = if result == 0
    "___"
  else
    result
  end

  puts "#{count.to_s.rjust(3, " ")} / #{max_id.to_s.ljust(3, "_")}" + "___" + class_name.to_s
end

puts "--------------------TABLE TOTALS (count/max id)---------------------"
puts "COUNT / MAX ID ___TABLE"

connection = ActiveRecord::Base.connection

ActiveRecord::Base.connection.tables.each do |table_name|
  unless ["ar_internal_metadata", "schema_migrations", "tags", "taggings"].include?(table_name)
    begin
      table_has_id_column = check_table_has_id_column(table_name, connection)

      if table_has_id_column == true
        klass_name = table_name.singularize.classify.constantize
        check_table_count(table_name, connection, klass_name)
      else
        check_table_count(table_name, connection, table_name)
        puts "=======#{table_name + ': doesnt have an id column'}======="
      end
    rescue
      puts "=======#{table_name + ': is not able to be constantized'}======="
    end
  end
end
tables_without_defined_class = ["tags", "taggings"]
tables_without_defined_class.each do |table_name|
  check_table_count(table_name, connection, table_name)
end

puts "-----------------------------END----------------------------"
