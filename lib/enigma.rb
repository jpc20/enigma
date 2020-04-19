require "./lib/encryptor"
require "./lib/decryptor"

class Enigma

  attr_reader :encryptor, :decryptor
  def initialize
    @encryptor = Encryptor.new
    @decryptor = Decryptor.new
  end

  def todays_date
    Date.today.strftime(("%d%m%y"))
  end

  def generate_key
    key = ""
    5.times{ key.concat(rand(0..9).to_s)}
    key
  end

  def encrypt(message, key = generate_key, date = todays_date)
    @encryptor.encrypt(message, key, date)
  end

  def decrypt(encrypted_message, key, date = todays_date)
    @decryptor.decrypt(encrypted_message, key, date)
  end

  def crack(encrypted_message, date = todays_date)
    @decryptor.crack(encrypted_message, date)
  end

end
