#Файл для чтения .xml
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require "date"
require "rexml/document"

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"
abort "File not found" unless File.exist?(file_name)

file = File.new(file_name)
doc = REXML::Document.new(file)
file.close

day_costs = {}

doc.elements.each("expenses/expense") do |item|
  day_sum = item.attributes["amount"].to_i
  date_sum = Date.parse(item.attributes["date"])
  day_costs[date_sum] ||= 0
  day_costs[date_sum] += day_sum
end

month_costs = {}

day_costs.keys.each do |key|
  month_costs[key.strftime("%B %Y")] ||= 0
  month_costs[key.strftime("%B %Y")] += day_costs[key]
end

current_month = nil

day_costs.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month
    current_month = key.strftime("%B %Y")
    puts "\n\r#{current_month} -- expenses #{month_costs[current_month]}\n\r"
  end
  puts "#{key.day} day - #{day_costs[key]}"
end