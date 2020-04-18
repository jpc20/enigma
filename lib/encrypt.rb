require 'date'
require './lib/enigma'

handle = File.open(ARGV[0], "r")
message = handle.read
handle.close

enigma = Enigma.new
encrypted = enigma.encrypt(message)

writer = File.open(ARGV[1], "w")
writer.write(encrypted[:encryption])
writer.close

puts "Created #{ARGV[1]} with the key #{encrypted[:key]} and the date #{encrypted[:date]}"
