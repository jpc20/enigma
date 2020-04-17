class Enigma

  attr_reader :alphabet
  def initialize
    @alphabet = ("a".."z").to_a << " "
  end

  def encrypt(message, key, date)
    {
      encryption: encrypt_message(message, key, date),
      key: key,
      date: date
    }
  end

  def encrypt_message(message, key, date)
    encrypted = ""
    shifts = create_shifts(key, date)
    split_message(message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        new_index = (@alphabet.find_index(char) + shift_value) % 27
        encrypted.concat(@alphabet[new_index])
      end
    end
    encrypted
  end

  def split_message(message)
    message.chars.each_slice(4).to_a
  end

  def split_key(key)
    key_array = []
    key.chars.each_cons(2){|chars| key_array << chars.join}
    key_array.map { |char| char.to_i }
  end

  def date_to_offsets(date)
    (date.to_i ** 2).to_s.chars.last(4).map { |char| char.to_i }
  end

  def create_shifts(key, date)
    split_key(key).zip(date_to_offsets(date)).map { |nums| nums.reduce(:+) }
  end

  def find_new_index(chars)

  end

end
