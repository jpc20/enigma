require_relative "machine"
require_relative "key_finder"

class Decryptor < Machine

  def initialize
    @key_finder = Keyfinder.new
    super
  end

  def decrypt(encrypted_message, key, date = todays_date)
    {
      decryption: decrypt_message(encrypted_message, key, date),
      key: key,
      date: date
    }
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

  def crack(encrypted_message, date = todays_date)
    {
      decryption: crack_message(encrypted_message, date),
      key: find_key(encrypted_message, date),
      date: date
    }
  end

  def crack_message(encrypted_message, date)
    cracked = ""
    shifts = find_shifts(encrypted_message, date)
    split_message(encrypted_message).each do |encrypted_chars|
      encrypted_chars.zip(shifts).each do |encrypted_char, shift_value|
        cracked.concat(decrypt_character(encrypted_char, shift_value))
      end
    end
    cracked
  end

  def decrypt_character(char, shift)
    return char if !@alphabet.include?(char)
    new_index = (@alphabet.find_index(char) - shift) % 27
    @alphabet[new_index]
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

  def find_key(encrypted_message, date)
    @key_finder.find_key(encrypted_message, date)
  end

end
