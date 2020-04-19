require 'date'
require './lib/enigma'

handle = File.open(ARGV[0], "r")
encrypted = handle.read
handle.close

enigma = Enigma.new
cracked = enigma.crack(encrypted, ARGV[2])

writer = File.open(ARGV[1], "w")
writer.write(cracked[:decryption])
writer.close

puts "Created #{ARGV[1]} with the key #{cracked[:key]} and the date #{cracked[:date]}"
