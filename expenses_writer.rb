if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require "date"
require "rexml/document"

file_name = File.dirname(__FILE__) + "/my_expenses.xml"
abort "File not found" unless File.exist?(file_name)
file = File.new(file_name, "r:UTF-8")
begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => e
  abort "Incorrect XML File"
  e.message
end
file.close

puts "\nWhat did you spend money on?\n"
exp_text = STDIN.gets.chomp
puts "\nHow much?\n"
exp_amount = STDIN.gets.chomp.to_i
puts "\nWhen? (format DD.MM.YYYY)\n"

begin
  input = STDIN.gets.chomp

  if input == ""
    exp_date = Date.today
    puts "That means today\n"
  else
    exp_date = Date.parse(input)
  end

rescue ArgumentError
  puts "\nIncorrect date format. That means today\n"
  exp_date = Date.today
end

puts "\nCategory?\n"
exp_category = STDIN.gets.chomp

doc.root.add_element("expense", "date" => exp_date,
                     "category" => exp_category,
                     "amount" => exp_amount,
).add_text(exp_text)

file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close
puts "\nExpense saved"