require 'date'
require './lib/enigma'

handle = File.open(ARGV[0], "r")
encrypted = handle.read
handle.close

enigma = Enigma.new
decrypted = enigma.decrypt(encrypted, ARGV[2], ARGV[3])

writer = File.open(ARGV[1], "w")
writer.write(decrypted[:decryption])
writer.close

puts "Created #{ARGV[1]} with the key #{decrypted[:key]} and the date #{decrypted[:date]}"
