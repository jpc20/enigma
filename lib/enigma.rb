class Enigma

  attr_reader :alphabet, :encryptor, :decryptor
  def initialize
    @alphabet = ("a".."z").to_a << " "
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
    {
      decryption: crack_message(encrypted_message, date),
      key: find_key(encrypted_message, date),
      date: date
    }
  end

  def encrypt_message(message, key, date)
    encrypted = ""
    shifts = create_shifts(key, date)
    split_message(message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        encrypted.concat(encrypt_character(char, shift_value))
      end
    end
    encrypted
  end

  def decrypt_message(encrypted_message, key, date)
    decrypted = ""
    shifts = create_shifts(key, date)
    split_message(encrypted_message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        decrypted.concat(decrypt_character(char, shift_value))
      end
    end
    decrypted
  end

  def crack_message(encrypted_message, date)
    cracked = ""
    shifts = find_shifts(encrypted_message, date)
    split_message(encrypted_message).each do |chars|
      chars.zip(shifts).each do |char, shift_value|
        cracked.concat(decrypt_character(char, shift_value))
      end
    end
    cracked
  end

  def split_message(message)
    message.chomp.chars.each_slice(4).to_a.map do |chars|
      chars.map { |char| char.downcase }
    end
  end

  def encrypt_character(char, shift)
    return char if !@alphabet.include?(char)
    new_index = (@alphabet.find_index(char) + shift) % 27
    @alphabet[new_index]
  end

  def decrypt_character(char, shift)
    return char if !@alphabet.include?(char)
    new_index = (@alphabet.find_index(char) - shift) % 27
    @alphabet[new_index]
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

  def find_key(encrypted_message, date)
    key  = ""
    offsets = date_to_offsets(date)
    find_shifts(encrypted_message, date).each_with_index do |shift, index|
      if index == 0
        key.concat(find_first_key(shift, offsets[index]))
      else
        find_next_key_value(key, index, offsets[index], shift)
      end
    end
    key
  end

  def find_first_key(shift, offset)
    if ((shift - offset) % 27).to_s.length == 1
      "0" + ((shift - offset) % 27).to_s
    else
      ((shift - offset) % 27).to_s
    end
  end

  def find_next_key_value(key, index, offset, shift)
    new_key_value = 0
    until key.length > index + 1
      if (key.chars.last.concat(new_key_value.to_s)).to_i % 27 == shift
        key.concat((((new_key_value - offset) % 27).to_s))
      end
      new_key_value += 1
    end
  end

  def find_shifts(encrypted_message, date)
    split_encrypted = split_message(encrypted_message)
    last_chars_length = split_encrypted.last.length
    end_array = [" ", "e", "n", "d"]
    if last_chars_length == 4
      shifts_for_multiple_of_4(split_encrypted, end_array)
    elsif last_chars_length < 4
      shifts_for_less_than_4_chars(split_encrypted, end_array, last_chars_length)
    end
  end

  def shifts_for_multiple_of_4(split_message, end_array)
    split_message.last.zip(end_array).map do |encrypted_char, end_char|
      shift_amount(encrypted_char, end_char)
    end
  end

  def shifts_for_less_than_4_chars(split_message, end_array, last_chars_length)
    shifts = split_message.last.zip(end_array.last(last_chars_length)).map do |encrypted_char, end_char|
      shift_amount(encrypted_char, end_char)
    end
    shifts << split_message[-2].last(4 - last_chars_length).each_with_index.map do |encrypted_char, index|
      shift_amount(encrypted_char, end_array[index])
    end
    shifts.flatten
  end

  def shift_amount(encrypted_char, end_char)
    (@alphabet.find_index(encrypted_char) - @alphabet.find_index(end_char)) % 27
  end

end
