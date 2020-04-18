require './test/test_helper'
require './lib/enigma'

handle = File.open(ARGV[0], "r")
message = handle.read
handle.close

enigma = Enigma.new
encrypted = enigma.encrypt(message)

writer = File.open(ARGV[1], "w")
writer.write(encrypted)
writer.close
