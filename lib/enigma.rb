require "./lib/encryptor"
require "./lib/decryptor"
require "./lib/code_breaker"

class Enigma

  attr_reader :encryptor, :decryptor, :code_breaker
  def initialize
    @encryptor = Encryptor.new
    @decryptor = Decryptor.new
    @code_breaker = CodeBreaker.new
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
    @code_breaker.crack(encrypted_message, date)
  end

end
